import SwiftUI

struct BoundaryCoordinateSheetView: View {
  @Binding var isTooltipVisible: Bool
  var onHelpTap: (() -> Void)?
  var onAddCoordinateTap: (() -> Void)?

  init(
    isTooltipVisible: Binding<Bool> = .constant(false),
    onHelpTap: (() -> Void)? = nil,
    onAddCoordinateTap: (() -> Void)? = nil
  ) {
    _isTooltipVisible = isTooltipVisible
    self.onHelpTap = onHelpTap
    self.onAddCoordinateTap = onAddCoordinateTap
  }

  var body: some View {
    VStack(spacing: 12) {
      // Pinned Header Row (remains visible when sheet is collapsed at bottom)
      HStack {
        Text("Boundary Coordinate")
          .font(.headline)
          .foregroundStyle(.primary)

        Spacer()

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
      .padding(.horizontal, 20)
      .padding(.top, 16)

      // Collapsible Content Area
      ScrollView(.vertical, showsIndicators: false) {
        VStack(spacing: 16) {
          // Empty State Container
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

          // Native Action Button
          Button(action: {
            onAddCoordinateTap?()
          }) {
            Label("Add Coordinate", systemImage: "plus")
              .font(.body.weight(.semibold))
              .frame(maxWidth: .infinity)
          }
          .buttonStyle(.bordered)
          .buttonBorderShape(.roundedRectangle(radius: 14))
          .controlSize(.large)
          .tint(.blue)
          .frame(minHeight: 44)
          .accessibilityLabel("Add Coordinate")
          .accessibilityHint("Adds a new boundary coordinate point")
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
  }
}

#Preview("Light Mode") {
  @Previewable @State var selectedDetent: PresentationDetent = BoundaryCreationViewModel.defaultSheetDetent

  Text("Map Content")
    .sheet(isPresented: .constant(true)) {
      BoundaryCoordinateSheetView()
        .presentationPlacement(.leading)
        .presentationDetents(
          [
            BoundaryCreationViewModel.collapsedSheetDetent,
            BoundaryCreationViewModel.defaultSheetDetent,
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

#Preview("Dark Mode") {
  @Previewable @State var selectedDetent: PresentationDetent = BoundaryCreationViewModel.defaultSheetDetent

  Text("Map Content")
    .preferredColorScheme(.dark)
    .sheet(isPresented: .constant(true)) {
      BoundaryCoordinateSheetView()
        .presentationPlacement(.leading)
        .presentationDetents(
          [
            BoundaryCreationViewModel.collapsedSheetDetent,
            BoundaryCreationViewModel.defaultSheetDetent,
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
