//
//  ContentView.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/03.
//

import SwiftUI
import Combine

struct ContentView: View {
  @EnvironmentObject var dependancyContainer: DependancyContainer
  var body: some View {
    NavigationView {
      BookListView()
        .environmentObject(dependancyContainer.bookListViewConfiguration)
        .environmentObject(dependancyContainer)
    }
  }
}
