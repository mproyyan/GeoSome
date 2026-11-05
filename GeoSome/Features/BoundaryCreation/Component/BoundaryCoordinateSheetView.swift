import SwiftUI

struct BoundaryCoordinateSheetView: View {
  @Binding var isTooltipVisible: Bool
  var points: [BoundaryPoint]
  var boundaryPointsText: String
  var areaPrimaryText: String
  var areaSecondaryText: String
  var onHelpTap: (() -> Void)?
  var onAddCoordinateTap: (() -> Void)?
  var onSelectPoint: ((BoundaryPoint) -> Void)?

  init(
    isTooltipVisible: Binding<Bool> = .constant(false),
    points: [BoundaryPoint] = [],
    boundaryPointsText: String = "0 point",
    areaPrimaryText: String = "0 m²",
    areaSecondaryText: String = "0 ha",
    onHelpTap: (() -> Void)? = nil,
    onAddCoordinateTap: (() -> Void)? = nil,
    onSelectPoint: ((BoundaryPoint) -> Void)? = nil
  ) {
    _isTooltipVisible = isTooltipVisible
    self.points = points
    self.boundaryPointsText = boundaryPointsText
    self.areaPrimaryText = areaPrimaryText
    self.areaSecondaryText = areaSecondaryText
    self.onHelpTap = onHelpTap
    self.onAddCoordinateTap = onAddCoordinateTap
    self.onSelectPoint = onSelectPoint
  }

  private var showsSummarySection: Bool {
    points.count >= 3
  }

  var body: some View {
    VStack(alignment: .leading, spacing: 14) {
      if showsSummarySection {
        summarySection
          .padding(.horizontal, 20)
          .padding(.top, 20)
      }

      headerSection
        .padding(.horizontal, 20)
        .padding(.top, showsSummarySection ? 2 : 16)

      if points.isEmpty {
        ScrollView(.vertical, showsIndicators: false) {
          VStack(spacing: 16) {
            emptyStateCard
            addCoordinateButton
          }
          .padding(.horizontal, 20)
          .padding(.bottom, 16)
        }
      } else {
        coordinateListSection
          .padding(.horizontal, 20)

        addCoordinateButton
          .padding(.horizontal, 20)
          .padding(.bottom, 16)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }

  private var summarySection: some View {
    HStack(spacing: 10) {
      VStack(alignment: .leading, spacing: 8) {
        Text("Boundary Points")
          .font(.caption.weight(.semibold))
          .foregroundStyle(.tertiary)

        Text(boundaryPointsText)
          .font(.title3.weight(.bold))
          .foregroundStyle(.primary)

        Spacer(minLength: 0)
      }
      .padding(14)
      .frame(maxHeight: .infinity, alignment: .topLeading)
      .background(
        RoundedRectangle(cornerRadius: 18, style: .continuous)
          .fill(.background)
      )

      VStack(alignment: .leading, spacing: 4) {
        Text("Area")
          .font(.caption.weight(.semibold))
          .foregroundStyle(.tertiary)

        Text(areaPrimaryText)
          .font(.title3.weight(.bold))
          .foregroundStyle(.primary)
          .padding(.top, 4)

        Text(areaSecondaryText)
          .font(.caption)
          .foregroundStyle(.secondary)
      }
      .padding(14)
      .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
      .background(
        RoundedRectangle(cornerRadius: 18, style: .continuous)
          .fill(.background)
      )
    }
    .fixedSize(horizontal: false, vertical: true)
  }

  private var headerSection: some View {
    HStack {
      Text("Boundary Coordinate")
        .font(.headline)
        .foregroundStyle(.primary)

      Spacer()

      if !showsSummarySection {
        Button(action: {
          if let onHelpTap {
            onHelpTap()
          } else {
            isTooltipVisible.toggle()
          }
        }) {
          Image(systemName: "questionmark.circle")
            .font(.title3)
            .foregroundStyle(.secondary)
            .frame(minWidth: 44, minHeight: 44)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Help on boundary coordinates")
        .accessibilityHint("Shows instructions for adding boundary points")
        .popover(isPresented: $isTooltipVisible, arrowEdge: .bottom) {
          BoundaryTooltipView()
        }
      }
    }
  }

  private var emptyStateCard: some View {
    VStack(spacing: 6) {
      Text("Add boundary points")
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(.primary)

      Text("Tap the map or Add Coordinate to place points.\nYou need at least 3 to create a boundary.")
        .font(.footnote)
        .foregroundStyle(.secondary)
        .multilineTextAlignment(.center)
    }
    .frame(maxWidth: .infinity)
    .padding(.vertical, 20)
    .padding(.horizontal, 16)
    .background(
      RoundedRectangle(cornerRadius: 16, style: .continuous)
        .fill(.quaternary)
    )
    .accessibilityElement(children: .combine)
    .accessibilityLabel("Add boundary points. Tap the map or Add Coordinate to place points. You need at least 3 to create a boundary.")
  }

  private var coordinateListSection: some View {
    List {
      ForEach(Array(points.enumerated()), id: \.element.id) { index, point in
        Button {
          onSelectPoint?(point)
        } label: {
          HStack(spacing: 12) {
            Text("\(index + 1)")
              .font(.caption.weight(.semibold))
              .foregroundStyle(.white)
              .frame(width: 22, height: 22)
              .background(Circle().fill(.blue))

            Text(point.formattedCoordinate)
              .font(.subheadline.weight(.semibold))
              .foregroundStyle(.primary)
              .lineLimit(1)

            Spacer()

            Image(systemName: "chevron.right")
              .font(.caption.weight(.semibold))
              .foregroundStyle(.tertiary)
          }
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .listRowBackground(Color(.systemBackground))
        .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
      }
    }
    .listStyle(.plain)
    .scrollContentBackground(.hidden)
    .background(
      RoundedRectangle(cornerRadius: 20, style: .continuous)
        .fill(.background)
    )
    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
  }

  private var addCoordinateButton: some View {
    Button(action: {
      onAddCoordinateTap?()
    }) {
      Label("Add Coordinate", systemImage: "plus")
        .font(.body.weight(.semibold))
        .frame(maxWidth: .infinity)
    }
    .buttonStyle(.bordered)
    .buttonBorderShape(.roundedRectangle(radius: 18))
    .controlSize(.large)
    .tint(.blue)
    .frame(minHeight: 44)
    .accessibilityLabel("Add Coordinate")
    .accessibilityHint("Adds a new boundary coordinate point")
  }
}

#Preview("Empty State") {
  @Previewable @State var selectedDetent: PresentationDetent = BoundaryCreationViewModel.defaultSheetDetent

  Text("Map Content")
    .sheet(isPresented: .constant(true)) {
      BoundaryCoordinateSheetView()
        .presentationPlacement(.leading)
        .presentationDetents(
          [
            BoundaryCreationViewModel.collapsedSheetDetent,
            BoundaryCreationViewModel.defaultSheetDetent,
            BoundaryCreationViewModel.populatedSheetDetent,
            .medium,
            .large
          ],
          selection: $selectedDetent
        )
        .presentationDragIndicator(.visible)
        .presentationBackgroundInteraction(.enabled)
        .presentationContentInteraction(.scrolls)
        .interactiveDismissDisabled()
    }
}

#Preview("3+ Coordinates") {
  @Previewable @State var selectedDetent: PresentationDetent = BoundaryCreationViewModel.populatedSheetDetent
  @Previewable @State var editingPoint: BoundaryPoint?

  let samplePoints = [
    BoundaryPoint(latitude: -6.215432, longitude: 106.845321),
    BoundaryPoint(latitude: -6.215432, longitude: 106.845321),
    BoundaryPoint(latitude: -6.215432, longitude: 106.845321)
  ]

  Text("Map Content")
    .sheet(isPresented: .constant(true)) {
      BoundaryCoordinateSheetView(
        points: samplePoints,
        onSelectPoint: { point in
          editingPoint = point
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
        selection: $selectedDetent
      )
      .presentationDragIndicator(.visible)
      .presentationBackgroundInteraction(.enabled)
      .presentationContentInteraction(.scrolls)
      .interactiveDismissDisabled()
      .sheet(item: $editingPoint) { point in
        let index = samplePoints.firstIndex(where: { $0.id == point.id }) ?? 0
        BoundaryEditCoordinateSheetView(
          pointTitle: "CPT Point \(index + 1)",
          latitudeText: .constant(point.formattedLatitude),
          longitudeText: .constant(point.formattedLongitude)
        )
        .presentationPlacement(.leading)
        .presentationDetents([BoundaryCreationViewModel.editSheetDetent, .medium, .large])
        .presentationDragIndicator(.visible)
        .presentationBackgroundInteraction(.enabled)
      }
    }
}
