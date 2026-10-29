import Foundation

public struct Project: Identifiable, Hashable, Sendable {
  public let id: UUID
  public var name: String
  public var lastEdited: Date

  public init(
    id: UUID = UUID(),
    name: String,
    lastEdited: Date = Date()
  ) {
    self.id = id
    self.name = name
    self.lastEdited = lastEdited
  }

  public var formattedLastEdited: String {
    let calendar = Calendar.current
    let timeFormatter = DateFormatter()
    timeFormatter.dateFormat = "h:mm a"
    let timeString = timeFormatter.string(from: lastEdited)

    if calendar.isDateInToday(lastEdited) {
      let interval = Date().timeIntervalSince(lastEdited)
      if interval < 120 {
        return "Edited just now"
      }
      return "Edited today at \(timeString)"
    } else if calendar.isDateInYesterday(lastEdited) {
      return "Edited yesterday at \(timeString)"
    } else {
      let monthFormatter = DateFormatter()
      monthFormatter.dateFormat = "MMM d"
      let dateString = monthFormatter.string(from: lastEdited)
      return "Edited \(dateString) at \(timeString)"
    }
  }

  public static let sampleProjects: [Project] = [
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
