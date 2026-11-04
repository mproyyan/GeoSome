import SwiftUI

public struct BoundaryTopBarView: View {
  @Binding public var projectName: String
  public var canUndo: Bool
  public var canRedo: Bool
  public var canCreateProject: Bool
  public var onBackTap: (() -> Void)?
  public var onResetAnchorTap: (() -> Void)?
  public var onUndoTap: (() -> Void)?
  public var onRedoTap: (() -> Void)?
  public var onCreateProjectTap: (() -> Void)?

  @State private var isEditingName: Bool = false
  @FocusState private var isNameFocused: Bool

  public init(
    projectName: Binding<String>,
    canUndo: Bool = false,
    canRedo: Bool = false,
    canCreateProject: Bool = false,
    onBackTap: (() -> Void)? = nil,
    onResetAnchorTap: (() -> Void)? = nil,
    onUndoTap: (() -> Void)? = nil,
    onRedoTap: (() -> Void)? = nil,
    onCreateProjectTap: (() -> Void)? = nil
  ) {
    _projectName = projectName
    self.canUndo = canUndo
    self.canRedo = canRedo
    self.canCreateProject = canCreateProject
    self.onBackTap = onBackTap
    self.onResetAnchorTap = onResetAnchorTap
    self.onUndoTap = onUndoTap
    self.onRedoTap = onRedoTap
    self.onCreateProjectTap = onCreateProjectTap
  }

  public var body: some View {
    HStack(alignment: .center, spacing: 12) {
      // Left: Back button & Editable Project Name
      HStack(spacing: 12) {
        backButton
        projectNameSection
      }

      Spacer()

      // Right: Reset Anchor, Undo, Redo, Create Project
      HStack(spacing: 8) {
        resetAnchorButton
        undoButton
        redoButton
        createProjectButton
      }
    }
    .padding(.horizontal, 20)
    .padding(.top, 12)
    .padding(.bottom, 8)
  }

  // MARK: - Back Button

  private var backButton: some View {
    Button(action: {
      onBackTap?()
    }) {
      Image(systemName: "chevron.left")
        .font(.system(size: 16, weight: .semibold))
        .foregroundStyle(Color.primary)
        .frame(width: 40, height: 40)
        .background(.regularMaterial)
        .clipShape(Circle())
        .overlay(
          Circle()
            .stroke(Color.white.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
    .buttonStyle(BoundaryPillButtonStyle())
    .accessibilityLabel("Back")
  }

  // MARK: - Project Name

  private var projectNameSection: some View {
    HStack(spacing: 8) {
      if isEditingName {
        TextField("Project name", text: $projectName)
          .font(.system(size: 17, weight: .semibold))
          .foregroundStyle(Color.primary)
          .focused($isNameFocused)
          .onSubmit {
            isEditingName = false
          }
          .padding(.horizontal, 10)
          .padding(.vertical, 6)
          .background(.regularMaterial)
          .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
          .overlay(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
              .stroke(Color.blue.opacity(0.4), lineWidth: 1.5)
          )
          .frame(minWidth: 140, maxWidth: 220)

        Button(action: {
          isEditingName = false
        }) {
          Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 18))
            .foregroundStyle(Color.blue)
        }
      } else {
        Button(action: {
          isEditingName = true
          isNameFocused = true
        }) {
          HStack(spacing: 6) {
            Text(projectName.isEmpty ? "Project name" : projectName)
              .font(.system(size: 17, weight: .semibold))
              .foregroundStyle(Color.primary)

            Image(systemName: "pencil")
              .font(.system(size: 14, weight: .semibold))
              .foregroundStyle(Color.primary)
          }
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
      }
    }
  }

  // MARK: - Reset Anchor Button

  private var resetAnchorButton: some View {
    Button(action: {
      onResetAnchorTap?()
    }) {
      Text("Reset Anchor")
        .font(.system(size: 14, weight: .medium))
        .foregroundStyle(Color.primary)
        .padding(.horizontal, 16)
        .frame(height: 38)
        .background(.regularMaterial)
        .clipShape(Capsule())
        .overlay(
          Capsule()
            .stroke(Color.white.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
    .buttonStyle(BoundaryPillButtonStyle())
    .accessibilityLabel("Reset Anchor")
  }

  // MARK: - Undo Button

  private var undoButton: some View {
    Button(action: {
      onUndoTap?()
    }) {
      Image(systemName: "arrow.uturn.backward")
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(Color.primary.opacity(canUndo ? 1.0 : 0.85))
        .frame(width: 38, height: 38)
        .background(.regularMaterial)
        .clipShape(Circle())
        .overlay(
          Circle()
            .stroke(Color.white.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
    .buttonStyle(BoundaryPillButtonStyle())
    .accessibilityLabel("Undo")
  }

  // MARK: - Redo Button

  private var redoButton: some View {
    Button(action: {
      onRedoTap?()
    }) {
      Image(systemName: "arrow.uturn.forward")
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(Color.primary.opacity(canRedo ? 1.0 : 0.85))
        .frame(width: 38, height: 38)
        .background(.regularMaterial)
        .clipShape(Circle())
        .overlay(
          Circle()
            .stroke(Color.white.opacity(0.8), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 2)
    }
    .buttonStyle(BoundaryPillButtonStyle())
    .accessibilityLabel("Redo")
  }

  // MARK: - Create Project Button

  private var createProjectButton: some View {
    Button(action: {
      if canCreateProject {
        onCreateProjectTap?()
      }
    }) {
      Text("Create Project")
        .font(.system(size: 14, weight: .semibold))
        .foregroundStyle(canCreateProject ? Color.white : Color.secondary.opacity(0.7))
        .padding(.horizontal, 18)
        .frame(height: 38)
        .background(
          Group {
            if canCreateProject {
              Color.blue
            } else {
              Color.black.opacity(0.06)
                .background(.ultraThinMaterial)
            }
          }
        )
        .clipShape(Capsule())
        .overlay(
          Capsule()
            .stroke(Color.white.opacity(canCreateProject ? 0.3 : 0.6), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
    .disabled(!canCreateProject)
    .buttonStyle(BoundaryPillButtonStyle())
    .accessibilityLabel("Create Project")
  }
}
