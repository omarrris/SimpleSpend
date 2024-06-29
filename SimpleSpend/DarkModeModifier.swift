import SwiftUI

struct DarkModeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .preferredColorScheme(.dark)
    }
}

extension View {
    func darkMode() -> some View {
        self.modifier(DarkModeModifier())
    }
}
