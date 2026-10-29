import SwiftUI
#if canImport(UIKit)
  import UIKit
#endif

public struct EmptyProjectStateView: View {
  public init() {}

  public var body: some View {
    VStack(spacing: 12) {
      ZStack {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(Color.blue.opacity(0.12))
          .frame(width: 48, height: 48)

        Image(systemName: "doc")
          .font(.system(size: 22, weight: .regular))
          .foregroundStyle(Color.blue.opacity(0.75))
      }
      .padding(.bottom, 4)

      VStack(spacing: 4) {
        Text("No Project Files")
          .font(.system(size: 16, weight: .bold))
          .foregroundStyle(.primary)

        Text("Project files will appear here.")
          .font(.system(size: 13, weight: .regular))
          .foregroundStyle(.secondary)
      }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .padding(.vertical, 32)
    .accessibilityElement(children: .combine)
    .accessibilityLabel("No Project Files. Project files will appear here.")
  }
}

#Preview {
  EmptyProjectStateView()
    .frame(height: 260)
  #if canImport(UIKit)
    .background(Color(uiColor: .systemBackground))
  #endif
}
