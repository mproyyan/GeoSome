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
    VStack(spacing: 10) {
      // Map Layer Toggle Button
      Button(action: {
        onToggleMapLayer?()
      }) {
        Image(systemName: isSatelliteStyle ? "map.fill" : "map")
          .font(.system(size: 20, weight: .medium))
          .foregroundStyle(Color.primary)
          .frame(width: 46, height: 46)
          .background(.regularMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
          .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
              .stroke(Color.white.opacity(0.8), lineWidth: 1)
          )
          .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 3)
      }
      .buttonStyle(BoundaryPillButtonStyle())
      .accessibilityLabel("Change map layer")

      // Current Location Focus Button
      Button(action: {
        onFocusLocation?()
      }) {
        Image(systemName: "location")
          .font(.system(size: 20, weight: .medium))
          .foregroundStyle(Color.blue)
          .frame(width: 46, height: 46)
          .background(.regularMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
          .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
              .stroke(Color.white.opacity(0.8), lineWidth: 1)
          )
          .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 3)
      }
      .buttonStyle(BoundaryPillButtonStyle())
      .accessibilityLabel("Focus on current location")
    }
  }
}
