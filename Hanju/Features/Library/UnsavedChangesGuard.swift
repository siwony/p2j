import SwiftUI

/// UIKit supplies the attempted-dismiss callback missing from SwiftUI's iOS 17 API.
/// The system still owns the sheet and its gesture; the original delegate is forwarded.
struct UnsavedChangesGuard: UIViewControllerRepresentable {
    let isDirty: Bool
    let onAttempt: () -> Void

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIViewController(context: Context) -> ObserverController {
        let controller = ObserverController()
        controller.install = { [weak controller, weak coordinator = context.coordinator] in
            if let controller { coordinator?.attach(from: controller) }
        }
        return controller
    }

    func updateUIViewController(_ controller: ObserverController, context: Context) {
        context.coordinator.isDirty = isDirty
        context.coordinator.onAttempt = onAttempt
        context.coordinator.attach(from: controller)
    }

    static func dismantleUIViewController(_ controller: ObserverController, coordinator: Coordinator) {
        coordinator.detach()
    }

    final class ObserverController: UIViewController {
        var install: (() -> Void)?
        override func loadView() {
            view = UIView()
            view.isUserInteractionEnabled = false
        }
        override func viewDidAppear(_ animated: Bool) { super.viewDidAppear(animated); install?() }
        override func viewDidLayoutSubviews() { super.viewDidLayoutSubviews(); install?() }
        override func didMove(toParent parent: UIViewController?) { super.didMove(toParent: parent); install?() }
    }

    final class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
        var isDirty = false
        var onAttempt: (() -> Void)?
        private weak var presentation: UIPresentationController?
        private weak var original: (any UIAdaptivePresentationControllerDelegate)?

        func attach(from controller: UIViewController) {
            // Child controllers can inherit a presenter. Only the outer presented
            // controller owns the sheet's interactive dismissal delegate.
            var presented = controller
            while let parent = presented.parent { presented = parent }
            guard presented.presentingViewController != nil,
                  let target = presented.activePresentationController,
                  target.presentedViewController === presented,
                  target.delegate !== self else { return }
            detach()
            original = target.delegate
            presentation = target
            target.delegate = self
        }

        func detach() {
            if presentation?.delegate === self { presentation?.delegate = original }
            presentation = nil
            original = nil
        }

        func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
            !isDirty && (original?.presentationControllerShouldDismiss?(presentationController) ?? true)
        }
        func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
            if isDirty { onAttempt?() }
            original?.presentationControllerDidAttemptToDismiss?(presentationController)
        }
        func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
            original?.presentationControllerWillDismiss?(presentationController)
        }
        func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
            original?.presentationControllerDidDismiss?(presentationController)
        }
        override func responds(to selector: Selector!) -> Bool {
            super.responds(to: selector) || original?.responds(to: selector) == true
        }
        override func forwardingTarget(for selector: Selector!) -> Any? {
            if original?.responds(to: selector) == true { return original }
            return super.forwardingTarget(for: selector)
        }
    }
}
