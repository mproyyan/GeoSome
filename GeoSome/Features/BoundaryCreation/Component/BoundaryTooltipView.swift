import SwiftUI

struct BoundaryTooltipView: View {
  var message: String

  init(message: String = "Tap the map to add a boundary point.") {
    self.message = message
  }

  var body: some View {
    Label(message, systemImage: "hand.tap")
      .font(.subheadline.weight(.medium))
      .foregroundStyle(.tint)
      .padding(.horizontal, 16)
      .padding(.vertical, 12)
      .presentationCompactAdaptation(.popover)
      .accessibilityElement(children: .combine)
      .accessibilityLabel(message)
  }
}

#Preview {
  BoundaryTooltipView()
}
