import SwiftUI

struct LibraryView: View {
    enum Destination: Hashable { case archive }

    var body: some View {
        RoutineListView(archived: false)
            .navigationDestination(for: Destination.self) { _ in
                RoutineListView(archived: true)
            }
    }
}
