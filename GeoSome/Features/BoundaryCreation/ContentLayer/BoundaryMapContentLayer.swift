import MapKit
import SwiftUI

public struct BoundaryMapContentLayer: View {
  @Binding public var cameraPosition: MapCameraPosition
  @Binding public var isSatelliteStyle: Bool
  public var onMapTap: ((CLLocationCoordinate2D) -> Void)?

  public static let defaultCenter = CLLocationCoordinate2D(
    latitude: -6.2415,
    longitude: 106.8315
  )

  public static let defaultSpan = MKCoordinateSpan(
    latitudeDelta: 0.012,
    longitudeDelta: 0.012
  )

  public init(
    cameraPosition: Binding<MapCameraPosition>,
    isSatelliteStyle: Binding<Bool> = .constant(false),
    onMapTap: ((CLLocationCoordinate2D) -> Void)? = nil
  ) {
    _cameraPosition = cameraPosition
    _isSatelliteStyle = isSatelliteStyle
    self.onMapTap = onMapTap
  }

  public var body: some View {
    MapReader { proxy in
      Map(position: $cameraPosition) {
        UserAnnotation()
      }
      .mapStyle(isSatelliteStyle ? .hybrid(elevation: .realistic) : .standard(elevation: .realistic, pointsOfInterest: .all))
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
  StatefulPreviewWrapper(
    MapCameraPosition.region(
      MKCoordinateRegion(
        center: BoundaryMapContentLayer.defaultCenter,
        span: BoundaryMapContentLayer.defaultSpan
      )
    )
  ) { position in
    BoundaryMapContentLayer(
      cameraPosition: position,
      isSatelliteStyle: .constant(false)
    )
  }
}

private struct StatefulPreviewWrapper<Value, Content: View>: View {
  @State private var value: Value
  private let content: (Binding<Value>) -> Content

  init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
    _value = State(initialValue: initialValue)
    self.content = content
  }

  var body: some View {
    content($value)
  }
}
