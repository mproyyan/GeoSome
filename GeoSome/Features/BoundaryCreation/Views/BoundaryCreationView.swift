import MapKit
import SwiftUI

struct BoundaryCreationView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: BoundaryCreationViewModel

  init(viewModel: BoundaryCreationViewModel? = nil) {
    _viewModel = State(initialValue: viewModel ?? BoundaryCreationViewModel())
  }

  var body: some View {
    @Bindable var viewModel = viewModel

    ZStack {
      // Content Layer (MapKit)
      BoundaryMapContentLayer(
        cameraPosition: $viewModel.cameraPosition,
        isSatelliteStyle: viewModel.isSatelliteStyle,
        onMapTap: { coordinate in
          viewModel.handleMapTap(at: coordinate)
        }
      )

      // Bottom Overlay (Tooltip, Coordinate Sheet, Map Controls)
      bottomOverlay(viewModel: $viewModel)
    }
    .toolbar {
      BoundaryToolbarContent(
        projectName: $viewModel.projectName,
        canUndo: viewModel.canUndo,
        canRedo: viewModel.canRedo,
        canCreateProject: viewModel.canCreateProject,
        onResetAnchorTap: {
          withAnimation(.easeInOut(duration: 0.5)) {
            viewModel.resetAnchor()
          }
        },
        onUndoTap: {
          viewModel.undo()
        },
        onRedoTap: {
          viewModel.redo()
        },
        onCreateProjectTap: {
          viewModel.createProject()
        }
      )
    }
    .toolbarRole(.editor)
    .toolbarBackground(.visible, for: .navigationBar)
    .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
    .ignoresSafeArea(.keyboard)
  }

  private func bottomOverlay(viewModel: Bindable<BoundaryCreationViewModel>) -> some View {
    VStack {
      Spacer()

      HStack(alignment: .bottom) {
        // Bottom-left: Tooltip + Coordinate Sheet
        VStack(alignment: .leading, spacing: 8) {
          BoundaryTooltipView(
            isVisible: viewModel.isTooltipVisible,
            message: "Tap the map to add a boundary point.",
            onDismiss: {
              self.viewModel.dismissTooltip()
            }
          )
          .padding(.leading, 180)

          BoundaryCoordinateSheetView(
            onHelpTap: {
              withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                self.viewModel.toggleTooltip()
              }
            },
            onAddCoordinateTap: {
              self.viewModel.addCoordinate()
            }
          )
        }
        .padding(.leading, 24)
        .padding(.bottom, 20)

        Spacer()

        // Bottom-right: Map Controls
        BoundaryMapControlsView(
          isSatelliteStyle: self.viewModel.isSatelliteStyle,
          onToggleMapLayer: {
            withAnimation(.easeInOut(duration: 0.2)) {
              self.viewModel.toggleMapLayer()
            }
          },
          onFocusLocation: {
            withAnimation(.easeInOut(duration: 0.5)) {
              self.viewModel.focusLocation()
            }
          }
        )
        .padding(.trailing, 24)
        .padding(.bottom, 28)
      }
    }
  }
}

#Preview {
  NavigationStack {
    BoundaryCreationView()
  }
}
