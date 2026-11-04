import CoreLocation
import Foundation
import MapKit
import Observation
import SwiftUI

@MainActor
@Observable
final class BoundaryCreationViewModel {
  static let collapsedSheetDetent: PresentationDetent = .height(68)
  static let defaultSheetDetent: PresentationDetent = .height(260)

  var projectName: String
  var cameraPosition: MapCameraPosition
  var isSatelliteStyle: Bool
  var isCoordinateSheetPresented: Bool
  var selectedSheetDetent: PresentationDetent
  var isTooltipVisible: Bool

  private(set) var points: [BoundaryPoint]
  private(set) var canUndo: Bool = false
  private(set) var canRedo: Bool = false

  var canCreateProject: Bool {
    points.count >= 3
  }

  init(
    projectName: String = "Project name",
    cameraPosition: MapCameraPosition? = nil,
    isSatelliteStyle: Bool = false,
    isCoordinateSheetPresented: Bool = true,
    selectedSheetDetent: PresentationDetent = .height(260),
    isTooltipVisible: Bool = false,
    points: [BoundaryPoint] = []
  ) {
    self.projectName = projectName
    self.cameraPosition = cameraPosition ?? .region(BoundaryMapConfiguration.defaultRegion)
    self.isSatelliteStyle = isSatelliteStyle
    self.isCoordinateSheetPresented = isCoordinateSheetPresented
    self.selectedSheetDetent = selectedSheetDetent
    self.isTooltipVisible = isTooltipVisible
    self.points = points
  }

  // MARK: - Intents (Placeholders)

  func handleMapTap(at _: CLLocationCoordinate2D) {
    // Tapping the map placeholder
  }

  func addCoordinate() {
    // Add coordinate action placeholder
  }

  func toggleTooltip() {
    isTooltipVisible.toggle()
  }

  func dismissTooltip() {
    isTooltipVisible = false
  }

  func toggleMapLayer() {
    isSatelliteStyle.toggle()
  }

  func focusLocation() {
    cameraPosition = .region(BoundaryMapConfiguration.defaultRegion)
  }

  func resetAnchor() {
    cameraPosition = .region(BoundaryMapConfiguration.defaultRegion)
  }

  func undo() {
    // Undo action placeholder
  }

  func redo() {
    // Redo action placeholder
  }

  func createProject() {
    // Create project action placeholder
  }
}
