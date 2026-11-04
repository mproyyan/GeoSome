import SwiftUI

public struct BoundaryUILayer: View {
  @Binding public var isTooltipVisible: Bool
  public var isSatelliteStyle: Bool
  public var onHelpTap: (() -> Void)?
  public var onAddCoordinateTap: (() -> Void)?
  public var onToggleMapLayer: (() -> Void)?
  public var onFocusLocation: (() -> Void)?

  public init(
    isTooltipVisible: Binding<Bool> = .constant(true),
    isSatelliteStyle: Bool = false,
    onHelpTap: (() -> Void)? = nil,
    onAddCoordinateTap: (() -> Void)? = nil,
    onToggleMapLayer: (() -> Void)? = nil,
    onFocusLocation: (() -> Void)? = nil
  ) {
    _isTooltipVisible = isTooltipVisible
    self.isSatelliteStyle = isSatelliteStyle
    self.onHelpTap = onHelpTap
    self.onAddCoordinateTap = onAddCoordinateTap
    self.onToggleMapLayer = onToggleMapLayer
    self.onFocusLocation = onFocusLocation
  }

  public var body: some View {
    VStack {
      Spacer()

      // Bottom Area: Sheet on bottom left, Controls on bottom right
      HStack(alignment: .bottom) {
        // Bottom-left: Tooltip + Coordinate Sheet
        VStack(alignment: .leading, spacing: 8) {
          BoundaryTooltipView(
            isVisible: $isTooltipVisible,
            message: "Tap the map to add a boundary point."
          )
          .padding(.leading, 180)

          BoundaryCoordinateSheetView(
            onHelpTap: onHelpTap,
            onAddCoordinateTap: onAddCoordinateTap
          )
        }
        .padding(.leading, 24)
        .padding(.bottom, 20)

        Spacer()

        // Bottom-right: Map Controls
        BoundaryMapControlsView(
          isSatelliteStyle: isSatelliteStyle,
          onToggleMapLayer: onToggleMapLayer,
          onFocusLocation: onFocusLocation
        )
        .padding(.trailing, 24)
        .padding(.bottom, 28)
      }
    }
  }
}
