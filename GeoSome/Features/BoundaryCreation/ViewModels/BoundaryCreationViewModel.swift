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
  var activeSheet: SheetDestination?
  var selectedSheetDetent: PresentationDetent
  var isAddCoordinateSheetPresented: Bool
  var isDiscardConfirmationPresented: Bool
  var isInvalidCoordinateAlertPresented: Bool
  var coordinateInputText: String
  var isTooltipVisible: Bool

  private(set) var points: [BoundaryPoint]
  private(set) var canUndo: Bool = false
  private(set) var canRedo: Bool = false

  var canCreateProject: Bool {
    points.count >= 3
  }

  var hasUnsavedCoordinateInput: Bool {
    !coordinateInputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
  }

  var canSubmitCoordinate: Bool {
    hasUnsavedCoordinateInput
  }

  init(
    projectName: String = "Project name",
    cameraPosition: MapCameraPosition? = nil,
    isSatelliteStyle: Bool = false,
    activeSheet: SheetDestination? = nil,
    selectedSheetDetent: PresentationDetent = .height(260),
    isAddCoordinateSheetPresented: Bool = false,
    isDiscardConfirmationPresented: Bool = false,
    isInvalidCoordinateAlertPresented: Bool = false,
    coordinateInputText: String = "",
    isTooltipVisible: Bool = false,
    points: [BoundaryPoint] = []
  ) {
    self.projectName = projectName
    self.cameraPosition = cameraPosition ?? .region(BoundaryMapConfiguration.defaultRegion)
    self.isSatelliteStyle = isSatelliteStyle
    self.activeSheet = activeSheet
    self.selectedSheetDetent = selectedSheetDetent
    self.isAddCoordinateSheetPresented = isAddCoordinateSheetPresented
    self.isDiscardConfirmationPresented = isDiscardConfirmationPresented
    self.isInvalidCoordinateAlertPresented = isInvalidCoordinateAlertPresented
    self.coordinateInputText = coordinateInputText
    self.isTooltipVisible = isTooltipVisible
    self.points = points
  }

  // MARK: - Intents (Placeholders)

  func presentCoordinateSheet() {
    activeSheet = .boundaryCoordinate
  }

  func dismissCoordinateSheet() {
    isDiscardConfirmationPresented = false
    isInvalidCoordinateAlertPresented = false
    isAddCoordinateSheetPresented = false
    activeSheet = nil
  }

  func handleMapTap(at _: CLLocationCoordinate2D) {
    // Tapping the map placeholder
  }

  func addCoordinate() {
    isAddCoordinateSheetPresented = true
  }

  func requestDismissAddCoordinateSheet() {
    if hasUnsavedCoordinateInput {
      isDiscardConfirmationPresented = true
    } else {
      dismissAddCoordinateSheet()
    }
  }

  func confirmDiscardCoordinateInput() {
    dismissAddCoordinateSheet()
  }

  func dismissAddCoordinateSheet() {
    isDiscardConfirmationPresented = false
    isInvalidCoordinateAlertPresented = false
    coordinateInputText = ""
    isAddCoordinateSheetPresented = false
  }

  func submitCoordinate() {
    guard Self.isValidCoordinateInput(coordinateInputText) else {
      isInvalidCoordinateAlertPresented = true
      return
    }

    dismissAddCoordinateSheet()
  }

  static func isValidCoordinateInput(_ text: String) -> Bool {
    let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !trimmedText.isEmpty else { return false }

    let lines = trimmedText.components(separatedBy: .newlines)
    return lines.allSatisfy { isValidCoordinateLine($0) }
  }

  private static func isValidCoordinateLine(_ line: String) -> Bool {
    let trimmedLine = line.trimmingCharacters(in: .whitespaces)
    guard !trimmedLine.isEmpty else { return false }

    let parts = trimmedLine.split(separator: ",", omittingEmptySubsequences: false)
    guard parts.count == 2 else { return false }

    let latString = parts[0].trimmingCharacters(in: .whitespaces)
    let lonString = parts[1].trimmingCharacters(in: .whitespaces)

    guard
      let latitude = Double(latString),
      let longitude = Double(lonString),
      latitude.isFinite,
      longitude.isFinite
    else {
      return false
    }

    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    return CLLocationCoordinate2DIsValid(coordinate)
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
