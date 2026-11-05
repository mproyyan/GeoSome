import Foundation
import Observation
import SwiftUI

@MainActor
@Observable
final class ProjectViewModel {
  static let defaultSheetDetent: PresentationDetent = .fraction(0.44)
  static let expandedSheetDetent: PresentationDetent = .fraction(0.88)

  private(set) var projects: [Project]
  private(set) var selectedProject: Project?
  var isProjectSheetPresented: Bool = true
  var selectedSheetDetent: PresentationDetent
  var isShowingBoundaryCreation: Bool = false

  private static let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "h:mm a"
    return formatter
  }()

  private static let monthDayFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM d"
    return formatter
  }()

  init(
    projects: [Project]? = nil,
    selectedSheetDetent: PresentationDetent = .fraction(0.44)
  ) {
    self.projects = projects ?? Project.sampleProjects
    self.selectedSheetDetent = selectedSheetDetent
  }

  var hasProjects: Bool {
    !projects.isEmpty
  }

  // MARK: - Intents

  func startNewProject() {
    isProjectSheetPresented = false
    isShowingBoundaryCreation = true
  }

  func handleBoundaryCreationDismissed() {
    if !isShowingBoundaryCreation {
      isProjectSheetPresented = true
    }
  }

  func selectProject(_ project: Project) {
    selectedProject = project
  }

  func addProject(name: String) {
    guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
    let newProject = Project(name: name, lastEdited: Date())
    projects.insert(newProject, at: 0)
  }

  func deleteProject(id: UUID) {
    projects.removeAll { $0.id == id }
  }

  func clearAllProjects() {
    projects.removeAll()
  }

  func loadSampleProjects() {
    projects = Project.sampleProjects
  }

  // MARK: - Presentation Formatting

  func formattedLastEdited(for project: Project, relativeTo now: Date = Date()) -> String {
    Self.formatLastEdited(project.lastEdited, relativeTo: now)
  }

  static func formatLastEdited(
    _ date: Date,
    relativeTo now: Date = Date(),
    calendar: Calendar = .current
  ) -> String {
    let timeString = timeFormatter.string(from: date)

    if calendar.isDateInToday(date) {
      let interval = now.timeIntervalSince(date)
      if interval < 120 {
        return "Edited just now"
      }
      return "Edited today at \(timeString)"
    } else if calendar.isDateInYesterday(date) {
      return "Edited yesterday at \(timeString)"
    } else {
      let dateString = monthDayFormatter.string(from: date)
      return "Edited \(dateString) at \(timeString)"
    }
  }
}
