import SwiftUI

struct EmptyProjectStateView: View {
  var body: some View {
    ContentUnavailableView(
      "No Project Files",
      systemImage: "doc",
      description: Text("Project files will appear here.")
    )
  }
}

#Preview {
  EmptyProjectStateView()
    .frame(height: 260)
}
