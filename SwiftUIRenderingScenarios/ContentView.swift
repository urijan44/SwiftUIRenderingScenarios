//
//  ContentView.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/03.
//

import SwiftUI
import Combine

struct ContentView: View {
  var body: some View {
    NavigationView {
      Form {
        Section("Source of truth / Derived Data") {
          NavigationLink {
            BookListView()
          } label: {
            Text("Source of Truth / Derived Data")
          }
          NavigationLink {
            ViewInitCheck()
          } label: {
            Text("View init Check")
          }

        }
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Text("Hello, world!")
  }
}
