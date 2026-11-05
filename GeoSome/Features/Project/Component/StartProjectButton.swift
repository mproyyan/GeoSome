import SwiftUI

struct StartProjectButton: View {
  private let action: (() -> Void)?
  @State private var feedbackTrigger: Bool = false
  @Environment(\.colorSchemeContrast) private var contrast
  @Environment(\.accessibilityDifferentiateWithoutColor) private var differentiateWithoutColor
  @ScaledMetric(relativeTo: .body) private var minButtonHeight: CGFloat = 44

  init(action: (() -> Void)? = nil) {
    self.action = action
  }

  var body: some View {
    Button(action: {
      feedbackTrigger.toggle()
      AccessibilityCaptionCenter.shared.announce(
        "Starting new site investigation project.",
        soundDescription: "Haptic impact"
      )
      action?()
    }) {
      Label("Start Your Project", systemImage: "plus.circle.fill")
        .font(.body.weight(.semibold))
        .padding(.horizontal, 8)
    }
    .buttonStyle(.borderedProminent)
    .buttonBorderShape(.capsule)
    .controlSize(.large)
    .tint(.blue)
    .frame(minHeight: max(minButtonHeight, 44))
    .overlay(
      Capsule()
        .stroke(
          Color.white.opacity(contrast == .increased || differentiateWithoutColor ? 0.85 : 0),
          lineWidth: contrast == .increased ? 2 : 1.5
        )
    )
    .sensoryFeedback(.impact(weight: .medium), trigger: feedbackTrigger)
    .accessibilityLabel("Start Your Project")
    .accessibilityHint("Creates a new site investigation project")
    .accessibilityInputLabels(["Start Project", "Start Your Project", "New Project"])
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    StartProjectButton(action: {})
  }
}
