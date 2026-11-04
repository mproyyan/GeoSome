import SwiftUI

public struct BoundaryUILayer: View {
  @Binding public var projectName: String
  @Binding public var isTooltipVisible: Bool
  public var isSatelliteStyle: Bool
  public var canUndo: Bool
  public var canRedo: Bool
  public var canCreateProject: Bool

  public var onBackTap: (() -> Void)?
  public var onResetAnchorTap: (() -> Void)?
  public var onUndoTap: (() -> Void)?
  public var onRedoTap: (() -> Void)?
  public var onCreateProjectTap: (() -> Void)?
  public var onHelpTap: (() -> Void)?
  public var onAddCoordinateTap: (() -> Void)?
  public var onToggleMapLayer: (() -> Void)?
  public var onFocusLocation: (() -> Void)?

  public init(
    projectName: Binding<String>,
    isTooltipVisible: Binding<Bool> = .constant(true),
    isSatelliteStyle: Bool = false,
    canUndo: Bool = false,
    canRedo: Bool = false,
    canCreateProject: Bool = false,
    onBackTap: (() -> Void)? = nil,
    onResetAnchorTap: (() -> Void)? = nil,
    onUndoTap: (() -> Void)? = nil,
    onRedoTap: (() -> Void)? = nil,
    onCreateProjectTap: (() -> Void)? = nil,
    onHelpTap: (() -> Void)? = nil,
    onAddCoordinateTap: (() -> Void)? = nil,
    onToggleMapLayer: (() -> Void)? = nil,
    onFocusLocation: (() -> Void)? = nil
  ) {
    _projectName = projectName
    _isTooltipVisible = isTooltipVisible
    self.isSatelliteStyle = isSatelliteStyle
    self.canUndo = canUndo
    self.canRedo = canRedo
    self.canCreateProject = canCreateProject
    self.onBackTap = onBackTap
    self.onResetAnchorTap = onResetAnchorTap
    self.onUndoTap = onUndoTap
    self.onRedoTap = onRedoTap
    self.onCreateProjectTap = onCreateProjectTap
    self.onHelpTap = onHelpTap
    self.onAddCoordinateTap = onAddCoordinateTap
    self.onToggleMapLayer = onToggleMapLayer
    self.onFocusLocation = onFocusLocation
  }

  public var body: some View {
    VStack(spacing: 0) {
      // Top Bar
      BoundaryTopBarView(
        projectName: $projectName,
        canUndo: canUndo,
        canRedo: canRedo,
        canCreateProject: canCreateProject,
        onBackTap: onBackTap,
        onResetAnchorTap: onResetAnchorTap,
        onUndoTap: onUndoTap,
        onRedoTap: onRedoTap,
        onCreateProjectTap: onCreateProjectTap
      )

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
