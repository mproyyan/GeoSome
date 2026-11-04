import CoreLocation
import Foundation
import MapKit

struct BoundaryPoint: Identifiable, Equatable, Sendable {
  let id: UUID
  var latitude: Double
  var longitude: Double

  init(
    id: UUID = UUID(),
    latitude: Double,
    longitude: Double
  ) {
    self.id = id
    self.latitude = latitude
    self.longitude = longitude
  }

  init(
    id: UUID = UUID(),
    coordinate: CLLocationCoordinate2D
  ) {
    self.id = id
    latitude = coordinate.latitude
    longitude = coordinate.longitude
  }

  var coordinate: CLLocationCoordinate2D {
    CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
  }
}

enum BoundaryMapConfiguration {
  static let defaultCenter = CLLocationCoordinate2D(
    latitude: -6.2415,
    longitude: 106.8315
  )

  static let defaultSpan = MKCoordinateSpan(
    latitudeDelta: 0.012,
    longitudeDelta: 0.012
  )

  static var defaultRegion: MKCoordinateRegion {
    MKCoordinateRegion(
      center: defaultCenter,
      span: defaultSpan
    )
  }
}
