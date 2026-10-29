import SwiftUI
#if canImport(UIKit)
  import UIKit
#endif

public struct ProjectCardView: View {
  public let project: Project
  private let action: (() -> Void)?

  public init(
    project: Project,
    action: (() -> Void)? = nil
  ) {
    self.project = project
    self.action = action
  }

  public var body: some View {
    Button(action: {
      action?()
    }) {
      VStack(alignment: .leading, spacing: 0) {
        thumbnailView
        detailsView
      }
      .frame(width: 156, height: 144)
      #if canImport(UIKit)
        .background(Color(uiColor: .secondarySystemBackground))
      #else
        .background(Color.gray.opacity(0.12))
      #endif
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
          RoundedRectangle(cornerRadius: 14, style: .continuous)
            .stroke(Color.primary.opacity(0.06), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    .buttonStyle(CardButtonStyle())
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(project.name), \(project.formattedLastEdited)")
    .accessibilityHint("Opens this project")
  }

  private var thumbnailView: some View {
    ZStack {
      #if canImport(UIKit)
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(Color(uiColor: .tertiarySystemFill))
      #else
        RoundedRectangle(cornerRadius: 12, style: .continuous)
          .fill(Color.gray.opacity(0.2))
      #endif

      Image(systemName: "map")
        .font(.system(size: 24, weight: .light))
        .foregroundStyle(.secondary)
    }
    .frame(height: 88)
    .padding(4)
  }

  private var detailsView: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text(project.name)
        .font(.system(size: 13, weight: .bold))
        .foregroundStyle(.primary)
        .lineLimit(1)

      Text(project.formattedLastEdited)
        .font(.system(size: 10, weight: .regular))
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
  }
}

private struct CardButtonStyle: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
      .opacity(configuration.isPressed ? 0.9 : 1.0)
      .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
  }
}

#Preview {
  HStack(spacing: 12) {
    ProjectCardView(project: Project.sampleProjects[0])
    ProjectCardView(project: Project.sampleProjects[1])
  }
  .padding()
}
