import Foundation

struct Project: Identifiable, Hashable, Sendable {
  let id: UUID
  var name: String
  var lastEdited: Date

  init(
    id: UUID = UUID(),
    name: String,
    lastEdited: Date = Date()
  ) {
    self.id = id
    self.name = name
    self.lastEdited = lastEdited
  }

  static let sampleProjects: [Project] = [
    Project(
      name: "Mampang Office",
      lastEdited: Calendar.current.date(byAdding: .day, value: -14, to: Date()) ?? Date()
    ),
    Project(
      name: "Project 2",
      lastEdited: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
    ),
    Project(
      name: "Cisauk Residential",
      lastEdited: Date()
    )
  ]
}
