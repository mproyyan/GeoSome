import CoreLocation
import Foundation
import MapKit

struct Project: Identifiable, Hashable, Codable, Sendable {
  let id: UUID
  var name: String
  var lastEdited: Date
  var boundaryPoints: [BoundaryPoint]

  init(
    id: UUID = UUID(),
    name: String,
    lastEdited: Date = Date(),
    boundaryPoints: [BoundaryPoint] = []
  ) {
    self.id = id
    self.name = name
    self.lastEdited = lastEdited
    self.boundaryPoints = boundaryPoints
  }

  var boundaryCoordinates: [CLLocationCoordinate2D] {
    boundaryPoints.map(\.coordinate)
  }

  var boundaryRegion: MKCoordinateRegion {
    guard let first = boundaryPoints.first else {
      return BoundaryMapConfiguration.defaultRegion
    }

    var minLat = first.latitude
    var maxLat = first.latitude
    var minLon = first.longitude
    var maxLon = first.longitude

    for point in boundaryPoints {
      minLat = min(minLat, point.latitude)
      maxLat = max(maxLat, point.latitude)
      minLon = min(minLon, point.longitude)
      maxLon = max(maxLon, point.longitude)
    }

    let center = CLLocationCoordinate2D(
      latitude: (minLat + maxLat) / 2,
      longitude: (minLon + maxLon) / 2
    )
    let span = MKCoordinateSpan(
      latitudeDelta: max((maxLat - minLat) * 1.8, 0.002),
      longitudeDelta: max((maxLon - minLon) * 1.8, 0.002)
    )
    return MKCoordinateRegion(center: center, span: span)
  }
}

protocol ProjectStorageProtocol {
  func loadProjects() -> [Project]
  func saveProjects(_ projects: [Project])
}

struct LocalProjectStorage: ProjectStorageProtocol {
  private let fileURL: URL

  init(fileURL: URL? = nil) {
    if let fileURL {
      self.fileURL = fileURL
    } else {
      let baseDirectory =
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first ??
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first ??
        URL.temporaryDirectory
      self.fileURL = baseDirectory.appendingPathComponent("projects.json")
    }
  }

  func loadProjects() -> [Project] {
    guard
      FileManager.default.fileExists(atPath: fileURL.path),
      let data = try? Data(contentsOf: fileURL),
      let decoded = try? JSONDecoder().decode([Project].self, from: data)
    else {
      return []
    }
    return decoded
  }

  func saveProjects(_ projects: [Project]) {
    let directoryURL = fileURL.deletingLastPathComponent()
    try? FileManager.default.createDirectory(
      at: directoryURL,
      withIntermediateDirectories: true
    )
    guard let data = try? JSONEncoder().encode(projects) else { return }
    try? data.write(to: fileURL, options: .atomic)
  }
}
