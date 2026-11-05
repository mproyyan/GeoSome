import SwiftUI

struct BoundaryToolbarContent: ToolbarContent {
  @Binding var projectName: String
  var canUndo: Bool
  var canRedo: Bool
  var canCreateProject: Bool
  var onBeginEditingName: (() -> Void)?
  var onFinishEditingName: (() -> Void)?
  var onResetAnchorTap: (() -> Void)?
  var onUndoTap: (() -> Void)?
  var onRedoTap: (() -> Void)?
  var onCreateProjectTap: (() -> Void)?

  init(
    projectName: Binding<String>,
    canUndo: Bool = false,
    canRedo: Bool = false,
    canCreateProject: Bool = true,
    onBeginEditingName: (() -> Void)? = nil,
    onFinishEditingName: (() -> Void)? = nil,
    onResetAnchorTap: (() -> Void)? = nil,
    onUndoTap: (() -> Void)? = nil,
    onRedoTap: (() -> Void)? = nil,
    onCreateProjectTap: (() -> Void)? = nil
  ) {
    _projectName = projectName
    self.canUndo = canUndo
    self.canRedo = canRedo
    self.canCreateProject = canCreateProject
    self.onBeginEditingName = onBeginEditingName
    self.onFinishEditingName = onFinishEditingName
    self.onResetAnchorTap = onResetAnchorTap
    self.onUndoTap = onUndoTap
    self.onRedoTap = onRedoTap
    self.onCreateProjectTap = onCreateProjectTap
  }

  var body: some ToolbarContent {
    // Leading: Editable Project Name (next to native back button)
    ToolbarItem(placement: .topBarLeading) {
      BoundaryProjectNameView(
        projectName: $projectName,
        onBeginEditing: onBeginEditingName,
        onFinishEditing: onFinishEditingName
      )
    }
    .sharedBackgroundVisibility(.hidden)

    // Trailing: Reset Anchor, Undo, Redo, Create Project
    ToolbarItemGroup(placement: .topBarTrailing) {
      HStack(spacing: 8) {
        // Reset Anchor
        Button(action: {
          onResetAnchorTap?()
        }) {
          Text("Reset Anchor")
            .font(.system(size: 14, weight: .medium))
            .foregroundStyle(Color.primary)
            .padding(.horizontal, 14)
            .frame(height: 36)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 1)
        }
        .frame(minWidth: 44, minHeight: 44)
        .buttonStyle(.glass(.regular))
        .buttonBorderShape(.automatic)
        .accessibilityLabel("Reset Anchor")

        // Undo
        Button(action: {
          onUndoTap?()
        }) {
          Image(systemName: "arrow.uturn.backward")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Color.primary.opacity(canUndo ? 1.0 : 0.4))
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 1)
        }
        .frame(minWidth: 44, minHeight: 44)
        .disabled(!canUndo)
        .buttonStyle(.glass(.regular))
        .buttonBorderShape(.automatic)
        .accessibilityLabel("Undo")

        // Redo
        Button(action: {
          onRedoTap?()
        }) {
          Image(systemName: "arrow.uturn.forward")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(Color.primary.opacity(canRedo ? 1.0 : 0.4))
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            .shadow(color: Color.black.opacity(0.08), radius: 4, x: 0, y: 1)
        }
        .frame(minWidth: 44, minHeight: 44)
        .disabled(!canRedo)
        .buttonStyle(.glass(.regular))
        .buttonBorderShape(.automatic)
        .accessibilityLabel("Redo")

        // Create Project
        Button(action: {
          if canCreateProject {
            onCreateProjectTap?()
          }
        }) {
          Text("Create Project")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(canCreateProject ? Color.white : Color.primary.opacity(0.4))
            .padding(.horizontal, 16)
            .frame(height: 36)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 1)
        }
        .frame(minWidth: 44, minHeight: 44)
        .disabled(!canCreateProject)
        .buttonStyle(.glass(canCreateProject ? .regular.tint(.blue) : .regular))
        .buttonBorderShape(.automatic)
        .accessibilityLabel("Create Project")
      }
    }
    .sharedBackgroundVisibility(.hidden)
  }
}

struct BoundaryProjectNameView: View {
  @Binding var projectName: String
  var onBeginEditing: (() -> Void)?
  var onFinishEditing: (() -> Void)?
  @State private var isEditing: Bool = false
  @FocusState private var isFocused: Bool

  init(
    projectName: Binding<String>,
    onBeginEditing: (() -> Void)? = nil,
    onFinishEditing: (() -> Void)? = nil
  ) {
    _projectName = projectName
    self.onBeginEditing = onBeginEditing
    self.onFinishEditing = onFinishEditing
  }

  var body: some View {
    HStack(spacing: 6) {
      if isEditing {
        TextField("Project name", text: $projectName)
          .font(.system(size: 17, weight: .semibold))
          .foregroundStyle(Color.primary)
          .focused($isFocused)
          .onSubmit {
            isEditing = false
            onFinishEditing?()
          }
          .padding(.horizontal, 10)
          .padding(.vertical, 5)
          .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
          .frame(minWidth: 140, maxWidth: 220)

        Button(action: {
          isEditing = false
          onFinishEditing?()
        }) {
          Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 18))
            .foregroundStyle(Color.blue)
        }
        .buttonStyle(.plain)
      } else {
        Button(action: {
          onBeginEditing?()
          isEditing = true
          isFocused = true
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
          .fixedSize()
          .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .layoutPriority(1)
        .frame(minHeight: 44)
        .accessibilityLabel("Project name: \(projectName). Tap to edit.")
      }
    }
    .onChange(of: isFocused) { _, focused in
      if !focused, isEditing {
        isEditing = false
        onFinishEditing?()
      }
    }
  }
}
