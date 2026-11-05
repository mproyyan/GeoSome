import MapKit
import SwiftUI

struct ProjectCardView: View {
  let project: Project
  let formattedLastEdited: String
  private let action: (() -> Void)?

  init(
    project: Project,
    formattedLastEdited: String? = nil,
    action: (() -> Void)? = nil
  ) {
    self.project = project
    self.formattedLastEdited = formattedLastEdited ?? ProjectViewModel.formatLastEdited(project.lastEdited)
    self.action = action
  }

  var body: some View {
    Button(action: {
      action?()
    }) {
      VStack(alignment: .leading, spacing: 0) {
        thumbnailView
        detailsView
      }
      .frame(width: 156, height: 144)
      .background(.quaternary)
      .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
      .overlay(
        RoundedRectangle(cornerRadius: 14, style: .continuous)
          .stroke(Color.primary.opacity(0.06), lineWidth: 1)
      )
      .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
    }
    .buttonStyle(.plain)
    .accessibilityElement(children: .combine)
    .accessibilityLabel("\(project.name), \(formattedLastEdited)")
    .accessibilityHint("Opens this project")
  }

  private var thumbnailView: some View {
    Map(
      position: .constant(.region(project.boundaryRegion)),
      interactionModes: []
    ) {
      if project.boundaryCoordinates.count >= 3 {
        MapPolygon(coordinates: project.boundaryCoordinates)
          .foregroundStyle(.blue.opacity(0.22))
          .stroke(.blue, lineWidth: 2)
      } else if project.boundaryCoordinates.count == 2 {
        MapPolyline(coordinates: project.boundaryCoordinates)
          .stroke(.blue, lineWidth: 2)
      }
    }
    .mapStyle(.standard(elevation: .realistic))
    .mapControlVisibility(.hidden)
    .allowsHitTesting(false)
    .frame(height: 88)
    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    .padding(4)
  }

  private var detailsView: some View {
    VStack(alignment: .leading, spacing: 3) {
      Text(project.name)
        .font(.footnote.weight(.bold))
        .foregroundStyle(.primary)
        .lineLimit(1)

      Text(formattedLastEdited)
        .font(.caption2)
        .foregroundStyle(.secondary)
        .lineLimit(1)
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .padding(.horizontal, 10)
    .padding(.vertical, 8)
  }
}

#Preview {
  ProjectCardView(
    project: Project(
      name: "Project name",
      boundaryPoints: [
        BoundaryPoint(latitude: -6.2402, longitude: 106.8295),
        BoundaryPoint(latitude: -6.2398, longitude: 106.8328),
        BoundaryPoint(latitude: -6.2426, longitude: 106.8334)
      ]
    )
  )
  .padding()
}
