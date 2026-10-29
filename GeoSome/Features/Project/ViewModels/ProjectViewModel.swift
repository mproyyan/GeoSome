import Foundation
import Observation

@Observable
public final class ProjectViewModel {
  public var projects: [Project]
  public var selectedProject: Project?

  public init(projects: [Project] = Project.sampleProjects) {
    self.projects = projects
  }

  public var hasProjects: Bool {
    !projects.isEmpty
  }

  public func addProject(name: String) {
    guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    let newProject = Project(name: name, lastEdited: Date())
    projects.insert(newProject, at: 0)
  }

  public func deleteProject(id: UUID) {
    projects.removeAll { $0.id == id }
  }

  public func clearAllProjects() {
    projects.removeAll()
  }

  public func loadSampleProjects() {
    projects = Project.sampleProjects
  }
}
