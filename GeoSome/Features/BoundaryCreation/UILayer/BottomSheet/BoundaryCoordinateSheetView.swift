import SwiftUI

public struct BoundaryCoordinateSheetView: View {
  public var onHelpTap: (() -> Void)?
  public var onAddCoordinateTap: (() -> Void)?

  public init(
    onHelpTap: (() -> Void)? = nil,
    onAddCoordinateTap: (() -> Void)? = nil
  ) {
    self.onHelpTap = onHelpTap
    self.onAddCoordinateTap = onAddCoordinateTap
  }

  public var body: some View {
    VStack(spacing: 16) {
      // Drag handle
      Capsule()
        .fill(Color.secondary.opacity(0.35))
        .frame(width: 36, height: 5)
        .padding(.top, 4)

      // Header row
      HStack {
        Text("Boundary Coordinate")
          .font(.system(size: 18, weight: .bold))
          .foregroundStyle(Color.primary)

        Spacer()

        Button(action: {
          onHelpTap?()
        }) {
          Image(systemName: "questionmark.circle")
            .font(.system(size: 20))
            .foregroundStyle(Color.primary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Help on boundary coordinates")
      }
      .padding(.horizontal, 4)

      // Empty State Inner Container
      VStack(spacing: 6) {
        Text("Add boundary points")
          .font(.system(size: 15, weight: .semibold))
          .foregroundStyle(Color.primary.opacity(0.85))

        Text("Tap the map or Add Coordinate to place points.\nYou need at least 3 to create a boundary.")
          .font(.system(size: 13, weight: .regular))
          .foregroundStyle(Color.secondary)
          .multilineTextAlignment(.center)
          .lineSpacing(3)
      }
      .frame(maxWidth: .infinity)
      .padding(.vertical, 20)
      .padding(.horizontal, 16)
      .background(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .fill(Color.white.opacity(0.55))
      )
      .overlay(
        RoundedRectangle(cornerRadius: 16, style: .continuous)
          .stroke(Color.white.opacity(0.8), lineWidth: 1)
      )

      // Add Coordinate Button
      Button(action: {
        onAddCoordinateTap?()
      }) {
        HStack(spacing: 6) {
          Image(systemName: "plus")
            .font(.system(size: 15, weight: .semibold))

          Text("Add Coordinate")
            .font(.system(size: 15, weight: .semibold))
        }
        .foregroundStyle(Color.blue)
        .frame(maxWidth: .infinity)
        .frame(height: 46)
        .background(
          LinearGradient(
            colors: [
              Color.blue.opacity(0.08),
              Color.blue.opacity(0.14)
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
          RoundedRectangle(cornerRadius: 14, style: .continuous)
            .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
      }
      .buttonStyle(BoundaryPillButtonStyle())
      .accessibilityLabel("Add Coordinate")
    }
    .padding(20)
    .frame(width: 350)
    .background(.regularMaterial)
    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    .overlay(
      RoundedRectangle(cornerRadius: 24, style: .continuous)
        .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
    )
    .shadow(color: Color.black.opacity(0.12), radius: 18, x: 0, y: 8)
  }
}
