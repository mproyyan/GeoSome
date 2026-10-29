import SwiftUI
#if canImport(UIKit)
  import UIKit
#endif

public struct ProjectListSheet: View {
  public let projects: [Project]
  public var onSelectProject: ((Project) -> Void)?
  public var minHeightRatio: CGFloat
  public var maxHeightRatio: CGFloat

  @State private var isExpanded: Bool = false
  @State private var dragOffset: CGFloat = 0

  public init(
    projects: [Project],
    minHeightRatio: CGFloat = 0.44,
    maxHeightRatio: CGFloat = 0.88,
    onSelectProject: ((Project) -> Void)? = nil
  ) {
    self.projects = projects
    self.minHeightRatio = minHeightRatio
    self.maxHeightRatio = maxHeightRatio
    self.onSelectProject = onSelectProject
  }

  public var body: some View {
    GeometryReader { geometry in
      let screenHeight = geometry.size.height
      let minHeight = screenHeight * minHeightRatio
      let maxHeight = screenHeight * maxHeightRatio
      let baseHeight = isExpanded ? maxHeight : minHeight
      let rawHeight = baseHeight - dragOffset

      // Prevent dragging below minHeight (rubber-band resistance)
      let clampedHeight: CGFloat = if rawHeight < minHeight {
        minHeight - (minHeight - rawHeight) * 0.2
      } else if rawHeight > maxHeight {
        maxHeight + (rawHeight - maxHeight) * 0.2
      } else {
        rawHeight
      }

      VStack(spacing: 0) {
        // Drag Indicator & Header (Gesture target)
        VStack(spacing: 8) {
          Capsule()
            .fill(Color.secondary.opacity(0.35))
            .frame(width: 36, height: 5)
            .padding(.top, 10)

          Text("All Projects")
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(.primary)
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .gesture(
          DragGesture(minimumDistance: 5)
            .onChanged { value in
              dragOffset = value.translation.height
            }
            .onEnded { value in
              let predictedEnd = value.predictedEndTranslation.height
              withAnimation(.spring(response: 0.35, dampingFraction: 0.82)) {
                if predictedEnd < -50 || value.translation.height < -60 {
                  isExpanded = true
                } else if predictedEnd > 50 || value.translation.height > 60 {
                  isExpanded = false
                }
                dragOffset = 0
              }
            }
        )

        // Sheet Content
        if projects.isEmpty {
          EmptyProjectStateView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(alignment: .top, spacing: 14) {
              ForEach(projects) { project in
                ProjectCardView(project: project) {
                  onSelectProject?(project)
                }
              }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 4)
          }
          .frame(height: 156, alignment: .topLeading)
          .padding(.top, 4)

          Spacer()
        }
      }
      .frame(width: geometry.size.width, height: clampedHeight, alignment: .top)
      #if canImport(UIKit)
        .background(Color(uiColor: .systemBackground))
      #else
        .background(Color.white)
      #endif
        .clipShape(
          UnevenRoundedRectangle(
            topLeadingRadius: 28,
            bottomLeadingRadius: 0,
            bottomTrailingRadius: 0,
            topTrailingRadius: 28,
            style: .continuous
          )
        )
        .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: -4)
        .frame(maxHeight: .infinity, alignment: .bottom)
    }
  }
}

#Preview("With Projects") {
  ZStack {
    Color.black.ignoresSafeArea()
    ProjectListSheet(projects: Project.sampleProjects)
  }
}

#Preview("Single Project") {
  ZStack {
    Color.black.ignoresSafeArea()
    ProjectListSheet(projects: [Project.sampleProjects[0]])
  }
}

#Preview("Empty State") {
  ZStack {
    Color.black.ignoresSafeArea()
    ProjectListSheet(projects: [])
  }
}
