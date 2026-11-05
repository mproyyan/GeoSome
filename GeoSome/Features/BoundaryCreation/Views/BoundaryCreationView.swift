import MapKit
import SwiftUI

struct BoundaryCreationView: View {
  @Environment(AppRouter.self) private var router
  @State private var viewModel: BoundaryCreationViewModel

  init(viewModel: BoundaryCreationViewModel? = nil) {
    _viewModel = State(initialValue: viewModel ?? BoundaryCreationViewModel())
  }

  private var isCurrentDestination: Bool {
    router.currentRoute == .boundaryCreation
  }

  private var sheetBinding: Binding<SheetDestination?> {
    Binding(
      get: { isCurrentDestination ? viewModel.activeSheet : nil },
      set: { viewModel.activeSheet = $0 }
    )
  }

  private var addCoordinateSheetBinding: Binding<Bool> {
    Binding(
      get: { isCurrentDestination && viewModel.isAddCoordinateSheetPresented },
      set: { viewModel.isAddCoordinateSheetPresented = $0 }
    )
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
    .sheet(item: sheetBinding) { destination in
      switch destination {
      case .boundaryCoordinate:
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
        .sheet(isPresented: addCoordinateSheetBinding) {
          BoundaryAddCoordinateSheetView(
            coordinateText: $viewModel.coordinateInputText,
            isDiscardConfirmationPresented: $viewModel.isDiscardConfirmationPresented,
            isInvalidCoordinateAlertPresented: $viewModel.isInvalidCoordinateAlertPresented,
            canSubmit: viewModel.canSubmitCoordinate,
            onCloseTap: {
              viewModel.requestDismissAddCoordinateSheet()
            },
            onDiscardConfirm: {
              viewModel.confirmDiscardCoordinateInput()
            },
            onSubmitTap: {
              viewModel.submitCoordinate()
            }
          )
          .presentationPlacement(.leading)
          .presentationDetents(
            [
              BoundaryCreationViewModel.defaultSheetDetent,
              .medium,
              .large
            ]
          )
          .presentationDragIndicator(.visible)
          .presentationBackgroundInteraction(.enabled)
          .interactiveDismissDisabled(viewModel.hasUnsavedCoordinateInput)
        }
      case .projectList:
        EmptyView()
      }
    }
    .task {
      try? await Task.sleep(for: .milliseconds(450))
      if !Task.isCancelled, isCurrentDestination {
        viewModel.presentCoordinateSheet()
      }
    }
    .onDisappear {
      viewModel.dismissCoordinateSheet()
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
  .environment(AppRouter(initialPath: [.boundaryCreation]))
}
