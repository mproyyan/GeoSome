import Foundation

enum AppRoute: Hashable {
  case boundaryCreation
  case projectDetail(id: Project.ID)
}

enum SheetDestination: String, Identifiable, Hashable {
  case projectList
  case boundaryCoordinate

  var id: String {
    rawValue
  }
}
