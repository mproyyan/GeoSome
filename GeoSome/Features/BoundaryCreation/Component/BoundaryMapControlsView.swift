import SwiftUI

struct BoundaryMapControlsView: View {
  var isSatelliteStyle: Bool
  var onToggleMapLayer: (() -> Void)?
  var onFocusLocation: (() -> Void)?

  init(
    isSatelliteStyle: Bool = false,
    onToggleMapLayer: (() -> Void)? = nil,
    onFocusLocation: (() -> Void)? = nil
  ) {
    self.isSatelliteStyle = isSatelliteStyle
    self.onToggleMapLayer = onToggleMapLayer
    self.onFocusLocation = onFocusLocation
  }

  var body: some View {
    VStack(spacing: 0) {
      // Top: Map Layer Toggle Button
      Button(action: {
        onToggleMapLayer?()
      }) {
        Image(systemName: isSatelliteStyle ? "map.fill" : "map")
          .font(.body.weight(.medium))
          .imageScale(.large)
          .foregroundStyle(.primary)
          .frame(width: 46, height: 46)
          .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .accessibilityLabel("Change map layer")
      .accessibilityValue(isSatelliteStyle ? "Satellite" : "Standard")
      .accessibilityHint("Switches between standard and satellite map views")

      Divider()
        .frame(width: 46)

      // Bottom: Current Location Focus Button
      Button(action: {
        onFocusLocation?()
      }) {
        Image(systemName: "location")
          .font(.body.weight(.medium))
          .imageScale(.large)
          .foregroundStyle(.blue)
          .frame(width: 46, height: 46)
          .contentShape(Rectangle())
      }
      .buttonStyle(.plain)
      .accessibilityLabel("Focus on current location")
      .accessibilityHint("Centers the map on the default anchor location")
    }
    .frame(width: 46)
    .glassEffect(
      .regular.interactive(),
      in: RoundedRectangle(cornerRadius: 12, style: .continuous)
    )
    .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 3)
  }
}

#Preview {
  ZStack {
    Color.gray.opacity(0.3).ignoresSafeArea()
    BoundaryMapControlsView()
  }
}
