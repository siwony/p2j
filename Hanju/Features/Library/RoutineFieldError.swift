import SwiftUI

struct RoutineFieldError: View {
    let message: String
    var body: some View {
        Label(message, systemImage: "exclamationmark.circle")
            .font(.callout)
            .accessibilityIdentifier("routine.error")
    }
}
