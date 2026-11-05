import SwiftUI

struct BoundaryTooltipView: View {
  var message: String
  @Environment(\.colorSchemeContrast) private var contrast

  init(message: String = "Tap the map to add a boundary point.") {
    self.message = message
  }

  var body: some View {
    Label(message, systemImage: "hand.tap")
      .font(.subheadline.weight(.medium))
      .foregroundStyle(contrast == .increased ? Color.primary : Color.accentColor)
      .fixedSize(horizontal: false, vertical: true)
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
