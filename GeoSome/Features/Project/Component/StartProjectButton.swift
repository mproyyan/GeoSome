import SwiftUI

public struct StartProjectButton: View {
  private let action: (() -> Void)?

  public init(action: (() -> Void)? = nil) {
    self.action = action
  }

  public var body: some View {
    Button(action: {
      #if os(iOS)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
      #endif
      action?()
    }) {
      HStack(spacing: 8) {
        Image(systemName: "plus")
          .font(.system(size: 15, weight: .semibold))
        Text("Start Your Project")
          .font(.system(size: 15, weight: .semibold))
      }
      .foregroundStyle(.white)
      .padding(.horizontal, 24)
      .padding(.vertical, 14)
      .background(Color.blue)
      .clipShape(Capsule())
      .shadow(color: Color.black.opacity(0.15), radius: 6, x: 0, y: 3)
    }
    .buttonStyle(PressableButtonStyle())
    .accessibilityLabel("Start Your Project")
    .accessibilityHint("Creates a new site investigation project")
  }
}

private struct PressableButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
      .opacity(configuration.isPressed ? 0.9 : 1.0)
      .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    StartProjectButton(action: {})
  }
}
