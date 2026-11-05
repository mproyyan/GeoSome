import MapKit
import SwiftUI

struct BoundaryMapContentLayer: View {
  @Binding var cameraPosition: MapCameraPosition
  var points: [BoundaryPoint]
  var isSatelliteStyle: Bool
  var onMapTap: ((CLLocationCoordinate2D) -> Void)?

  init(
    cameraPosition: Binding<MapCameraPosition>,
    points: [BoundaryPoint] = [],
    isSatelliteStyle: Bool = false,
    onMapTap: ((CLLocationCoordinate2D) -> Void)? = nil
  ) {
    _cameraPosition = cameraPosition
    self.points = points
    self.isSatelliteStyle = isSatelliteStyle
    self.onMapTap = onMapTap
  }

  private var coordinates: [CLLocationCoordinate2D] {
    points.map(\.coordinate)
  }

  var body: some View {
    MapReader { proxy in
      Map(position: $cameraPosition) {
        UserAnnotation()

        if coordinates.count == 2 {
          MapPolyline(coordinates: coordinates)
            .stroke(.blue, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
        } else if coordinates.count >= 3 {
          MapPolygon(coordinates: coordinates)
            .foregroundStyle(.blue.opacity(0.22))
            .stroke(.blue, lineWidth: 3)
        }

        ForEach(Array(points.enumerated()), id: \.element.id) { index, point in
          Annotation("CPT Point \(index + 1)", coordinate: point.coordinate, anchor: .center) {
            Text("\(index + 1)")
              .font(.caption.weight(.bold))
              .foregroundStyle(.white)
              .frame(width: 28, height: 28)
              .background(.blue, in: .circle)
              .accessibilityLabel("Boundary point \(index + 1)")
          }
          .annotationTitles(.hidden)
        }
      }
      .mapStyle(
        isSatelliteStyle
          ? .hybrid(elevation: .realistic)
          : .standard(elevation: .realistic, pointsOfInterest: .all)
      )
      .mapControlVisibility(.hidden)
      .onTapGesture { screenPoint in
        if let coordinate = proxy.convert(screenPoint, from: .local) {
          onMapTap?(coordinate)
        }
      }
      .ignoresSafeArea()
    }
  }
}

#Preview {
  @Previewable @State var position = MapCameraPosition.region(BoundaryMapConfiguration.defaultRegion)

  let samplePoints = [
    BoundaryPoint(latitude: -6.2405, longitude: 106.8305),
    BoundaryPoint(latitude: -6.2425, longitude: 106.8330),
    BoundaryPoint(latitude: -6.2430, longitude: 106.8295)
  ]

  BoundaryMapContentLayer(
    cameraPosition: $position,
    points: samplePoints,
    isSatelliteStyle: false
  )
}
