import SwiftUI

struct EmptyProjectStateView: View {
  var body: some View {
    ContentUnavailableView(
      "No Project Files",
      systemImage: "doc",
      description: Text("Project files will appear here.")
    )
    .accessibilityElement(children: .combine)
    .accessibilityLabel("No Project Files. Project files will appear here.")
  }
}

#Preview {
  EmptyProjectStateView()
    .frame(height: 260)
}
