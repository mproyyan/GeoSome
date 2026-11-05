import SwiftUI

struct HomePage: View {
  @Environment(AppRouter.self) private var router
  @State private var viewModel: ProjectViewModel

  init(viewModel: ProjectViewModel? = nil) {
    _viewModel = State(initialValue: viewModel ?? ProjectViewModel())
  }

  private var sheetBinding: Binding<SheetDestination?> {
    Binding(
      get: { router.isAtRoot ? viewModel.activeSheet : nil },
      set: { viewModel.activeSheet = $0 }
    )
  }

  var body: some View {
    @Bindable var viewModel = viewModel

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
              .font(.largeTitle.weight(.bold))
              .foregroundStyle(.white)

            Text("Plan your site investigation with data-driven CPT recommendations.")
              .font(.subheadline)
              .foregroundStyle(.white.opacity(0.88))
              .multilineTextAlignment(.center)
              .padding(.horizontal, 32)
          }

          StartProjectButton(action: {
            viewModel.dismissProjectSheet()
            router.navigate(to: .boundaryCreation)
          })
          .padding(.top, 4)

          Spacer()
        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.56)
        .padding(.top, geometry.safeAreaInsets.top)
      }
      .ignoresSafeArea()
      .toolbar(.hidden, for: .navigationBar)
      .sheet(item: sheetBinding) { destination in
        switch destination {
        case .projectList:
          ProjectListSheet(
            projects: viewModel.projects,
            onSelectProject: { project in
              viewModel.selectProject(project)
              viewModel.dismissProjectSheet()
              router.navigate(to: .projectDetail(id: project.id))
            }
          )
          .presentationPlacement(.center)
          .presentationSizing(FullWidthPresentationSizing())
          .presentationDetents(
            [
              ProjectViewModel.defaultSheetDetent,
              ProjectViewModel.expandedSheetDetent
            ],
            selection: $viewModel.selectedSheetDetent
          )
          .presentationDragIndicator(.visible)
          .presentationBackground(.background)
          .presentationBackgroundInteraction(.enabled)
          .presentationContentInteraction(.scrolls)
          .interactiveDismissDisabled()
        case .boundaryCoordinate:
          EmptyView()
        }
      }
      .onChange(of: router.isAtRoot) { _, isAtRoot in
        if isAtRoot {
          Task {
            try? await Task.sleep(for: .milliseconds(550))
            if router.isAtRoot {
              viewModel.presentProjectSheet()
            }
          }
        }
      }
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
        .font(.title2.weight(.semibold))
        .foregroundStyle(.white)
    }
    .accessibilityElement(children: .ignore)
    .accessibilityLabel("GeoSome Logo")
  }
}

#Preview("Empty State") {
  HomePage(viewModel: ProjectViewModel(projects: []))
    .environment(AppRouter())
}
