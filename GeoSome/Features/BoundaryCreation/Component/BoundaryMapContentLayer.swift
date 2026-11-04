import MapKit
import SwiftUI

struct BoundaryMapContentLayer: View {
  @Binding var cameraPosition: MapCameraPosition
  var isSatelliteStyle: Bool
  var onMapTap: ((CLLocationCoordinate2D) -> Void)?

  init(
    cameraPosition: Binding<MapCameraPosition>,
    isSatelliteStyle: Bool = false,
    onMapTap: ((CLLocationCoordinate2D) -> Void)? = nil
  ) {
    _cameraPosition = cameraPosition
    self.isSatelliteStyle = isSatelliteStyle
    self.onMapTap = onMapTap
  }

  var body: some View {
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
    MapCameraPosition.region(BoundaryMapConfiguration.defaultRegion)
  ) { position in
    BoundaryMapContentLayer(
      cameraPosition: position,
      isSatelliteStyle: false
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
