import MapKit
import SwiftUI

public struct BoundaryCreationView: View {
  @Environment(\.dismiss) private var dismiss

  @State private var projectName: String = "Project name"
  @State private var cameraPosition: MapCameraPosition = .region(
    MKCoordinateRegion(
      center: BoundaryMapContentLayer.defaultCenter,
      span: BoundaryMapContentLayer.defaultSpan
    )
  )
  @State private var isSatelliteStyle: Bool = false
  @State private var isTooltipVisible: Bool = true
  @State private var canUndo: Bool = false
  @State private var canRedo: Bool = false
  @State private var canCreateProject: Bool = false

  public init() {}

  public var body: some View {
    ZStack {
      // Content Layer (MapKit)
      BoundaryMapContentLayer(
        cameraPosition: $cameraPosition,
        isSatelliteStyle: $isSatelliteStyle,
        onMapTap: { _ in
          // Tapping the map
        }
      )

      // UI Layer (Bottom Sheet, Tooltip, Map Controls)
      BoundaryUILayer(
        isTooltipVisible: $isTooltipVisible,
        isSatelliteStyle: isSatelliteStyle,
        onHelpTap: {
          withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            isTooltipVisible.toggle()
          }
        },
        onAddCoordinateTap: {
          // Add coordinate action placeholder
        },
        onToggleMapLayer: {
          withAnimation(.easeInOut(duration: 0.2)) {
            isSatelliteStyle.toggle()
          }
        },
        onFocusLocation: {
          withAnimation(.easeInOut(duration: 0.5)) {
            cameraPosition = .region(
              MKCoordinateRegion(
                center: BoundaryMapContentLayer.defaultCenter,
                span: BoundaryMapContentLayer.defaultSpan
              )
            )
          }
        }
      )
    }
    .toolbar {
      BoundaryToolbarContent(
        projectName: $projectName,
        canUndo: canUndo,
        canRedo: canRedo,
        canCreateProject: canCreateProject,
        onResetAnchorTap: {
          withAnimation(.easeInOut(duration: 0.5)) {
            cameraPosition = .region(
              MKCoordinateRegion(
                center: BoundaryMapContentLayer.defaultCenter,
                span: BoundaryMapContentLayer.defaultSpan
              )
            )
          }
        },
        onUndoTap: {
          // Undo action placeholder
        },
        onRedoTap: {
          // Redo action placeholder
        },
        onCreateProjectTap: {
          // Create project action placeholder
        }
      )
    }
    .toolbarRole(.editor)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    .ignoresSafeArea(.keyboard)
  }
}

#Preview {
  NavigationStack {
    BoundaryCreationView()
  }
}
