import SwiftUI

public struct HomePage: View {
  @State public var viewModel: ProjectViewModel

  public init(viewModel: ProjectViewModel = ProjectViewModel()) {
    _viewModel = State(initialValue: viewModel)
  }

  public var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .top) {
        // Fullscreen Hero Background
        heroBackgroundPlaceholder

        // Hero Content placed in the upper portion above the sheet resting line
        VStack(spacing: 16) {
          Spacer()

          logoPlaceholder

          VStack(spacing: 8) {
            Text("Terravise")
              .font(.system(size: 36, weight: .bold))
              .foregroundStyle(.white)

            Text("Plan your site investigation with data-driven CPT recommendations.")
              .font(.system(size: 14, weight: .regular))
              .foregroundStyle(.white.opacity(0.88))
              .multilineTextAlignment(.center)
              .padding(.horizontal, 32)
          }

          StartProjectButton()
            .padding(.top, 4)

          Spacer()
        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.56)
        .padding(.top, geometry.safeAreaInsets.top)

        // Interactive Full-Width Bottom Sheet (pinned to bottom, edge-to-edge)
        ProjectListSheet(
          projects: viewModel.projects,
          onSelectProject: { project in
            viewModel.selectedProject = project
          }
        )
      }
      .ignoresSafeArea()
    }
  }

  // MARK: - Placeholders

  private var heroBackgroundPlaceholder: some View {
    ZStack {
      LinearGradient(
        colors: [
          Color(red: 0.36, green: 0.28, blue: 0.24),
          Color(red: 0.28, green: 0.22, blue: 0.18),
          Color(red: 0.18, green: 0.14, blue: 0.12)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
      )

      Rectangle()
        .fill(
          RadialGradient(
            colors: [
              Color.white.opacity(0.08),
              Color.black.opacity(0.4)
            ],
            center: .center,
            startRadius: 40,
            endRadius: 400
          )
        )
    }
  }

  private var logoPlaceholder: some View {
    ZStack {
      RoundedRectangle(cornerRadius: 14, style: .continuous)
        .fill(
          LinearGradient(
            colors: [
              Color.green.opacity(0.9),
              Color.orange.opacity(0.85),
              Color.blue.opacity(0.9)
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
        .frame(width: 52, height: 48)
        .shadow(color: Color.black.opacity(0.25), radius: 8, x: 0, y: 4)

      Image(systemName: "square.3.layers.3d.down.right")
        .font(.system(size: 26, weight: .semibold))
        .foregroundStyle(.white)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("GeoSome Logo")
  }
}

#Preview("Populated") {
  HomePage(viewModel: ProjectViewModel(projects: Project.sampleProjects))
}

#Preview("Empty State") {
  HomePage(viewModel: ProjectViewModel(projects: []))
}
