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

    BoundaryMapContentLayer(
      cameraPosition: $viewModel.cameraPosition,
      isSatelliteStyle: viewModel.isSatelliteStyle,
      onMapTap: { coordinate in
        viewModel.handleMapTap(at: coordinate)
      }
    )
    .overlay(alignment: .bottomTrailing) {
      BoundaryMapControlsView(
        isSatelliteStyle: viewModel.isSatelliteStyle,
        onToggleMapLayer: {
          withAnimation(.easeInOut(duration: 0.2)) {
            viewModel.toggleMapLayer()
          }
        },
        onFocusLocation: {
          withAnimation(.easeInOut(duration: 0.5)) {
            viewModel.focusLocation()
          }
        }
      )
      .padding(.trailing, 20)
      .padding(.bottom, 28)
    }
    .sheet(isPresented: $viewModel.isCoordinateSheetPresented) {
      BoundaryCoordinateSheetView(
        isTooltipVisible: $viewModel.isTooltipVisible,
        onHelpTap: {
          viewModel.toggleTooltip()
        },
        onAddCoordinateTap: {
          viewModel.addCoordinate()
        }
      )
      .presentationPlacement(.leading)
      .presentationDetents(
        [
          BoundaryCreationViewModel.collapsedSheetDetent,
          BoundaryCreationViewModel.defaultSheetDetent,
          .medium,
          .large
        ],
        selection: $viewModel.selectedSheetDetent
      )
      .presentationDragIndicator(.visible)
      .presentationBackgroundInteraction(.enabled)
      .presentationContentInteraction(.scrolls)
      .interactiveDismissDisabled()
    }
    .onAppear {
      viewModel.isCoordinateSheetPresented = true
    }
    .onDisappear {
      viewModel.isCoordinateSheetPresented = false
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
}

#Preview {
  NavigationStack {
    BoundaryCreationView()
  }
}
