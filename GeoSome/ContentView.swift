//
//  ContentView.swift
//  GeoSome
//
//  Created by Muhammad Pandu Royyan on 28/10/26.
//

import SwiftUI

struct ContentView: View {
  @State private var router = AppRouter()

  var body: some View {
    NavigationStack(path: $router.path) {
      HomePage()
        .withAppRouter()
    }
    .environment(router)
  }
}

#Preview {
  ContentView()
}
