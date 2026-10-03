"""Exercise commit-msg with real Git commits, rebases, and linked worktrees."""

import os
from pathlib import Path
import shlex
import shutil
import subprocess
import sys
import tempfile
import unittest


HOOK = Path(__file__).resolve().parents[2] / ".githooks" / "commit-msg"
BRANCH = "codex/fix/16-rebase-hook"
SUBJECT = "fix(tooling): validate hook (#16)"


class CommitMessageHookTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory(prefix="p2j-commit-hook-")
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.repo = self.root / "repo"
        self.repo.mkdir()
        self.env = os.environ.copy()
        for key in ("GIT_DIR", "GIT_WORK_TREE", "GIT_INDEX_FILE", "GIT_COMMON_DIR"):
            self.env.pop(key, None)
        self.env.update(GIT_CONFIG_NOSYSTEM="1", GIT_CONFIG_GLOBAL=os.devnull)
        self.git("-c", "init.templateDir=", "init", "--initial-branch=main")
        self.git("config", "user.name", "Hook test")
        self.git("config", "user.email", "hook-test@example.invalid")
        self.git("config", "commit.gpgsign", "false")
        (self.repo / "sample.txt").write_text("base\n")
        self.git("add", "sample.txt")
        self.git("commit", "-m", "fixture base")
        self.hooks = self.root / "hooks"
        self.hooks.mkdir()
        shutil.copy2(HOOK, self.hooks / "commit-msg")
        self.git("config", "core.hooksPath", str(self.hooks))
        self.git("switch", "-c", BRANCH)
        sequence = self.root / "sequence.py"
        sequence.write_text(
            "import pathlib, sys\n"
            "p = pathlib.Path(sys.argv[1])\n"
            "p.write_text(p.read_text().replace('pick ', 'reword ', 1))\n"
        )
        editor = self.root / "message.py"
        editor.write_text(
            "import os, pathlib, sys\n"
            "pathlib.Path(sys.argv[1]).write_text(os.environ['TEST_SUBJECT'] + '\\n')\n"
        )
        self.env["GIT_SEQUENCE_EDITOR"] = shlex.join([sys.executable, str(sequence)])
        self.env["GIT_EDITOR"] = shlex.join([sys.executable, str(editor)])
        self.env["TEST_SUBJECT"] = SUBJECT

    def git(self, *args, ok=True, repo=None):
        result = subprocess.run(
            ["git", *args], cwd=repo or self.repo, env=self.env,
            capture_output=True, text=True,
        )
        if ok:
            self.assertEqual(result.returncode, 0, result.stdout + result.stderr)
        else:
            self.assertNotEqual(result.returncode, 0, result.stdout + result.stderr)
        return result

    def commit(self, subject=SUBJECT, **kwargs):
        # A real tree change is needed: reword may reject empty commits before hooks.
        repo = kwargs.get("repo") or self.repo
        change = repo / "changes.txt"
        change.write_text((change.read_text() if change.exists() else "") + "change\n")
        self.git("add", "changes.txt", repo=repo)
        return self.git("commit", "-m", subject, **kwargs)

    def reword(self, **kwargs):
        return self.git("rebase", "-i", "HEAD~1", **kwargs)

    def assert_rejected(self, result):
        self.assertIn("커밋 거절:", result.stderr)

    def test_valid_commit_and_reword(self):
        self.commit()
        self.env["TEST_SUBJECT"] = "fix(tooling): reword succeeds (#16)"
        self.reword()
        self.assertEqual(self.git("log", "-1", "--format=%s").stdout.strip(),
                         self.env["TEST_SUBJECT"])
        self.assertEqual(self.git("branch", "--show-current").stdout.strip(), BRANCH)

    def test_reword_in_linked_worktree(self):
        worktree = self.root / "linked"
        self.git("worktree", "add", "-b", "codex/fix/16-linked", str(worktree))
        self.commit(repo=worktree)
        self.env["TEST_SUBJECT"] = "fix(tooling): linked reword succeeds (#16)"
        self.reword(repo=worktree)
        self.assertEqual(self.git("log", "-1", "--format=%s", repo=worktree).stdout.strip(),
                         self.env["TEST_SUBJECT"])

    def test_direct_main_detached_and_invalid_branch_rejected(self):
        for target in ("main", "--detach", "invalid-branch"):
            with self.subTest(target=target):
                if target == "invalid-branch":
                    self.git("switch", "-c", target)
                else:
                    self.git("switch", target)
                self.assert_rejected(self.commit(ok=False))

    def test_main_and_detached_reword_rejected(self):
        self.commit()
        self.git("branch", "-f", "main", "HEAD")
        for target in ("main", "--detach"):
            with self.subTest(target=target):
                self.git("switch", target)
                self.assert_rejected(self.reword(ok=False))
                self.git("rebase", "--abort")

    def test_issue_mismatch_during_commit_and_reword_rejected(self):
        wrong = "fix(tooling): wrong issue (#17)"
        self.assert_rejected(self.commit(wrong, ok=False))
        self.commit()
        self.env["TEST_SUBJECT"] = wrong
        self.assert_rejected(self.reword(ok=False))

    def test_invalid_subject_during_reword_rejected(self):
        self.commit()
        self.env["TEST_SUBJECT"] = "not a conventional commit"
        self.assert_rejected(self.reword(ok=False))

    def conflicting_history(self):
        (self.repo / "sample.txt").write_text("topic\n")
        self.git("add", "sample.txt")
        self.commit()
        upstream = self.root / "upstream"
        self.git("worktree", "add", "-b", "codex/fix/16-upstream", str(upstream), "main")
        (upstream / "sample.txt").write_text("upstream\n")
        self.git("add", "sample.txt", repo=upstream)
        self.commit(repo=upstream)
        return "codex/fix/16-upstream"

    def invoke_hook(self, ok):
        message = self.root / "COMMIT_EDITMSG"
        message.write_text(SUBJECT + "\n")
        result = subprocess.run(
            [sys.executable, str(self.hooks / "commit-msg"), str(message)],
            cwd=self.repo, env=self.env, capture_output=True, text=True,
        )
        self.assertEqual(result.returncode, 0 if ok else 1, result.stderr)
        return result

    def test_apply_rebase_uses_original_branch(self):
        upstream = self.conflicting_history()
        self.git("rebase", "--apply", upstream, ok=False)
        self.assertEqual(self.git("branch", "--show-current").stdout.strip(), "")
        self.invoke_hook(ok=True)
        (self.repo / "sample.txt").write_text("resolved\n")
        self.git("add", "sample.txt")
        self.git("rebase", "--continue")
        self.assertEqual(self.git("branch", "--show-current").stdout.strip(), BRANCH)

    def test_git_am_is_not_rebase(self):
        upstream = self.conflicting_history()
        patch = self.root / "change.patch"
        patch.write_text(self.git("format-patch", "-1", "--stdout").stdout)
        self.git("switch", "--detach", upstream)
        self.git("am", str(patch), ok=False)
        # Even an unrelated head-name file must not make an am session a rebase.
        state = Path(self.git("rev-parse", "--git-path", "rebase-apply").stdout.strip())
        if not state.is_absolute():
            state = self.repo / state
        (state / "head-name").write_text("refs/heads/" + BRANCH + "\n")
        self.assert_rejected(self.invoke_hook(ok=False))

    def test_invalid_or_missing_rebase_head_name_rejected(self):
        self.commit()
        self.env["TEST_SUBJECT"] = "invalid title"
        self.reword(ok=False)
        state = Path(self.git("rev-parse", "--git-path", "rebase-merge/head-name").stdout.strip())
        if not state.is_absolute():
            state = self.repo / state
        for contents in ("", "detached HEAD\n", "refs/tags/" + BRANCH,
                         "refs/heads/main\n", "refs/heads/invalid\n",
                         "refs/heads/" + BRANCH + "\nextra\n"):
            with self.subTest(contents=contents):
                state.write_text(contents)
                self.assert_rejected(self.invoke_hook(ok=False))
        state.unlink()
        self.assert_rejected(self.invoke_hook(ok=False))


if __name__ == "__main__":
    unittest.main(verbosity=2)
