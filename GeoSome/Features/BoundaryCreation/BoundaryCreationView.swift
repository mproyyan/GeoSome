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

  public var onBack: (() -> Void)?

  public init(onBack: (() -> Void)? = nil) {
    self.onBack = onBack
  }

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

      // UI Layer (Top bar, bottom sheet, tooltip, map controls)
      BoundaryUILayer(
        projectName: $projectName,
        isTooltipVisible: $isTooltipVisible,
        isSatelliteStyle: isSatelliteStyle,
        canUndo: canUndo,
        canRedo: canRedo,
        canCreateProject: canCreateProject,
        onBackTap: {
          if let onBack {
            onBack()
          } else {
            dismiss()
          }
        },
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
        },
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
    .navigationBarBackButtonHidden(true)
    .toolbar(.hidden, for: .navigationBar)
    .ignoresSafeArea(.keyboard)
  }
}

#Preview {
  BoundaryCreationView()
}
