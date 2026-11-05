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

  private var editCoordinateSheetBinding: Binding<BoundaryPoint?> {
    Binding(
      get: { isCurrentDestination ? viewModel.editingPoint : nil },
      set: { viewModel.editingPoint = $0 }
    )
  }

  var body: some View {
    @Bindable var viewModel = viewModel

    BoundaryMapContentLayer(
      cameraPosition: $viewModel.cameraPosition,
      points: viewModel.points,
      isSatelliteStyle: viewModel.isSatelliteStyle,
      onMapTap: { coordinate in
        viewModel.handleMapTap(at: coordinate)
      },
      onBeginMovePoint: {
        viewModel.beginPointDrag()
      },
      onMovePoint: { id, newCoordinate in
        viewModel.updatePointCoordinate(id: id, to: newCoordinate)
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
          points: viewModel.points,
          boundaryPointsText: viewModel.boundaryPointsSummaryText,
          areaPrimaryText: viewModel.areaSquareMetersText,
          areaSecondaryText: viewModel.areaHectaresText,
          onHelpTap: {
            viewModel.toggleTooltip()
          },
          onAddCoordinateTap: {
            viewModel.addCoordinate()
          },
          onSelectPoint: { point in
            viewModel.selectPointForEditing(point)
          }
        )
        .presentationPlacement(.leading)
        .presentationDetents(
          [
            BoundaryCreationViewModel.collapsedSheetDetent,
            BoundaryCreationViewModel.defaultSheetDetent,
            BoundaryCreationViewModel.populatedSheetDetent,
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
        .sheet(item: editCoordinateSheetBinding) { point in
          BoundaryEditCoordinateSheetView(
            pointTitle: viewModel.title(for: point),
            latitudeText: $viewModel.editLatitudeText,
            longitudeText: $viewModel.editLongitudeText,
            isDeleteConfirmationPresented: $viewModel.isDeletePointAlertPresented,
            isDiscardConfirmationPresented: $viewModel.isEditDiscardConfirmationPresented,
            isInvalidCoordinateAlertPresented: $viewModel.isEditInvalidCoordinateAlertPresented,
            canSubmit: viewModel.canSubmitEditedCoordinate,
            onCloseTap: {
              viewModel.requestDismissEditCoordinateSheet()
            },
            onDiscardConfirm: {
              viewModel.confirmDiscardEditCoordinateChanges()
            },
            onSubmitTap: {
              viewModel.submitEditedCoordinate()
            },
            onDeleteTap: {
              viewModel.requestDeleteEditingPoint()
            },
            onDeleteConfirm: {
              viewModel.confirmDeleteEditingPoint()
            }
          )
          .presentationPlacement(.leading)
          .presentationDetents(
            [
              BoundaryCreationViewModel.editSheetDetent,
              .medium,
              .large
            ]
          )
          .presentationDragIndicator(.visible)
          .presentationBackgroundInteraction(.enabled)
          .interactiveDismissDisabled(viewModel.hasUnsavedEditCoordinateChanges)
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
