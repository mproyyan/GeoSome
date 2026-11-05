//
//  ContentView.swift
//  GeoSome
//
//  Created by Muhammad Pandu Royyan on 28/10/26.
//

import SwiftUI

struct ContentView: View {
  @State private var router = AppRouter()
  @State private var projectViewModel = ProjectViewModel()

  var body: some View {
    NavigationStack(path: $router.path) {
      HomePage(viewModel: projectViewModel)
        .withAppRouter()
    }
    .environment(router)
    .environment(projectViewModel)
  }
}

#Preview {
  ContentView()
}
