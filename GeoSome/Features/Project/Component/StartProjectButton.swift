import SwiftUI

struct StartProjectButton: View {
  private let action: (() -> Void)?
  @State private var feedbackTrigger: Bool = false

  init(action: (() -> Void)? = nil) {
    self.action = action
  }

  var body: some View {
    Button(action: {
      feedbackTrigger.toggle()
      action?()
    }) {
      Label("Start Your Project", systemImage: "plus")
        .font(.body.weight(.semibold))
        .padding(.horizontal, 8)
    }
    .buttonStyle(.borderedProminent)
    .buttonBorderShape(.capsule)
    .controlSize(.large)
    .tint(.blue)
    .frame(minHeight: 44)
    .sensoryFeedback(.impact(weight: .medium), trigger: feedbackTrigger)
    .accessibilityLabel("Start Your Project")
    .accessibilityHint("Creates a new site investigation project")
  }
}

#Preview {
  ZStack {
    Color.black.ignoresSafeArea()
    StartProjectButton(action: {})
  }
}
