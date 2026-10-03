import SwiftUI

/// Semantic colors mirror design/tokens.json; native text styles scale with Dynamic Type.
enum DesignTokens {
    static let accent = Color("AccentColor")
    static let background = Color("Background")
    static let surface = Color("Surface")
    static let textPrimary = Color("TextPrimary")
    static let textSecondary = Color("TextSecondary")
    static let spacing: CGFloat = 16
    static let screenInset: CGFloat = 24
}
