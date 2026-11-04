import SwiftUI

struct BoundaryTooltipView: View {
  @Binding var isVisible: Bool
  var message: String
  var onDismiss: (() -> Void)?

  init(
    isVisible: Binding<Bool>,
    message: String = "Tap the map to add a boundary point.",
    onDismiss: (() -> Void)? = nil
  ) {
    _isVisible = isVisible
    self.message = message
    self.onDismiss = onDismiss
  }

  var body: some View {
    if isVisible {
      VStack(alignment: .leading, spacing: 0) {
        HStack(spacing: 8) {
          Image(systemName: "hand.tap")
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(Color.blue)

          Text(message)
            .font(.system(size: 13, weight: .medium))
            .foregroundStyle(Color.blue)
            .lineLimit(1)

          Button(action: {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
              isVisible = false
            }
            onDismiss?()
          }) {
            Image(systemName: "xmark")
              .font(.system(size: 11, weight: .bold))
              .foregroundStyle(Color.secondary.opacity(0.8))
              .padding(4)
              .contentShape(Rectangle())
          }
          .buttonStyle(.plain)
          .accessibilityLabel("Dismiss tooltip")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
          RoundedRectangle(cornerRadius: 14, style: .continuous)
            .fill(Color.white)
            .shadow(color: Color.black.opacity(0.12), radius: 10, x: 0, y: 4)
        )
        .overlay(
          RoundedRectangle(cornerRadius: 14, style: .continuous)
            .stroke(Color.black.opacity(0.04), lineWidth: 1)
        )

        // Downward pointer arrow
        TooltipPointer()
          .fill(Color.white)
          .frame(width: 14, height: 7)
          .padding(.leading, 24)
          .offset(y: -1)
          .shadow(color: Color.black.opacity(0.08), radius: 2, x: 0, y: 2)
      }
      .transition(.asymmetric(
        insertion: .scale(scale: 0.8, anchor: .bottomLeading).combined(with: .opacity),
        removal: .scale(scale: 0.8, anchor: .bottomLeading).combined(with: .opacity)
      ))
    }
  }
}

private struct TooltipPointer: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.minY))
    path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
    path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
    path.closeSubpath()
    return path
  }
}
