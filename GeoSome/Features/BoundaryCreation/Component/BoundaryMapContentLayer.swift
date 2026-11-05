import MapKit
import SwiftUI

struct BoundaryMapContentLayer: View {
  @Binding var cameraPosition: MapCameraPosition
  var points: [BoundaryPoint]
  var isSatelliteStyle: Bool
  var onMapTap: ((CLLocationCoordinate2D) -> Void)?
  var onMovePoint: ((BoundaryPoint.ID, CLLocationCoordinate2D) -> Void)?

  @State private var draggingPointID: BoundaryPoint.ID?
  @State private var dragStartCoordinate: CLLocationCoordinate2D?
  @State private var lastPointInteractionTime: Date = .distantPast

  init(
    cameraPosition: Binding<MapCameraPosition>,
    points: [BoundaryPoint] = [],
    isSatelliteStyle: Bool = false,
    onMapTap: ((CLLocationCoordinate2D) -> Void)? = nil,
    onMovePoint: ((BoundaryPoint.ID, CLLocationCoordinate2D) -> Void)? = nil
  ) {
    _cameraPosition = cameraPosition
    self.points = points
    self.isSatelliteStyle = isSatelliteStyle
    self.onMapTap = onMapTap
    self.onMovePoint = onMovePoint
  }

  private var coordinates: [CLLocationCoordinate2D] {
    points.map(\.coordinate)
  }

  var body: some View {
    MapReader { proxy in
      Map(
        position: $cameraPosition,
        interactionModes: draggingPointID == nil ? .all : []
      ) {
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
          let isDraggingThisPoint = draggingPointID == point.id
          let anchorCoordinate = (isDraggingThisPoint ? dragStartCoordinate : nil) ?? point.coordinate

          Annotation("CPT Point \(index + 1)", coordinate: anchorCoordinate, anchor: .center) {
            interactivePointBadge(
              index: index,
              point: point,
              isDragging: isDraggingThisPoint,
              proxy: proxy
            )
          }
          .annotationTitles(.hidden)
        }

        if let draggingPointID,
           let draggedIndex = points.firstIndex(where: { $0.id == draggingPointID })
        {
          let draggedPoint = points[draggedIndex]
          Annotation(
            "CPT Point \(draggedIndex + 1) Preview",
            coordinate: draggedPoint.coordinate,
            anchor: .center
          ) {
            pointBadgeLabel(index: draggedIndex, isDragging: true)
              .allowsHitTesting(false)
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
        guard
          draggingPointID == nil,
          Date.now.timeIntervalSince(lastPointInteractionTime) > 0.3,
          !isScreenPointNearExistingAnnotation(screenPoint, proxy: proxy)
        else {
          return
        }

        if let coordinate = proxy.convert(screenPoint, from: .local) {
          onMapTap?(coordinate)
        }
      }
      .ignoresSafeArea()
    }
  }

  private func isScreenPointNearExistingAnnotation(
    _ screenPoint: CGPoint,
    proxy: MapProxy
  ) -> Bool {
    for point in points {
      if let existingScreenPoint = proxy.convert(point.coordinate, to: .local) {
        let distance = hypot(
          screenPoint.x - existingScreenPoint.x,
          screenPoint.y - existingScreenPoint.y
        )
        if distance < 28 {
          return true
        }
      }
    }
    return false
  }

  private func pointBadgeLabel(index: Int, isDragging: Bool) -> some View {
    Text("\(index + 1)")
      .font(.caption.weight(.bold))
      .foregroundStyle(.white)
      .frame(width: 28, height: 28)
      .background(.blue, in: .circle)
      .scaleEffect(isDragging ? 1.2 : 1.0)
      .shadow(
        color: .black.opacity(isDragging ? 0.25 : 0.12),
        radius: isDragging ? 6 : 2,
        y: 2
      )
  }

  private func interactivePointBadge(
    index: Int,
    point: BoundaryPoint,
    isDragging: Bool,
    proxy: MapProxy
  ) -> some View {
    pointBadgeLabel(index: index, isDragging: false)
      .opacity(isDragging ? 0 : 1)
      .frame(width: 44, height: 44)
      .contentShape(Circle())
      .highPriorityGesture(
        DragGesture(minimumDistance: 0)
          .onChanged { value in
            lastPointInteractionTime = .now

            if draggingPointID != point.id {
              draggingPointID = point.id
              dragStartCoordinate = point.coordinate
            }

            let distance = hypot(value.translation.width, value.translation.height)
            guard
              distance > 1,
              let startCoordinate = dragStartCoordinate,
              let startScreenPoint = proxy.convert(startCoordinate, to: .local)
            else {
              return
            }

            let targetScreenPoint = CGPoint(
              x: startScreenPoint.x + value.translation.width,
              y: startScreenPoint.y + value.translation.height
            )

            if let newCoordinate = proxy.convert(targetScreenPoint, from: .local) {
              onMovePoint?(point.id, newCoordinate)
            }
          }
          .onEnded { value in
            lastPointInteractionTime = .now

            let distance = hypot(value.translation.width, value.translation.height)
            if distance > 1,
               let startCoordinate = dragStartCoordinate,
               let startScreenPoint = proxy.convert(startCoordinate, to: .local)
            {
              let targetScreenPoint = CGPoint(
                x: startScreenPoint.x + value.translation.width,
                y: startScreenPoint.y + value.translation.height
              )
              if let finalCoordinate = proxy.convert(targetScreenPoint, from: .local) {
                onMovePoint?(point.id, finalCoordinate)
              }
            }

            draggingPointID = nil
            dragStartCoordinate = nil
          }
      )
      .accessibilityLabel("Boundary point \(index + 1)")
      .accessibilityHint("Drag to move this boundary point on the map")
  }
}

#Preview {
  @Previewable @State var position = MapCameraPosition.region(BoundaryMapConfiguration.defaultRegion)
  @Previewable @State var points = [
    BoundaryPoint(latitude: -6.2405, longitude: 106.8305),
    BoundaryPoint(latitude: -6.2425, longitude: 106.8330),
    BoundaryPoint(latitude: -6.2430, longitude: 106.8295)
  ]

  BoundaryMapContentLayer(
    cameraPosition: $position,
    points: points,
    isSatelliteStyle: false,
    onMovePoint: { id, newCoordinate in
      if let index = points.firstIndex(where: { $0.id == id }) {
        points[index].latitude = newCoordinate.latitude
        points[index].longitude = newCoordinate.longitude
      }
    }
  )
}
