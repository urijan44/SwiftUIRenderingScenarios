//
//  ContentView.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/03.
//

import SwiftUI
import Combine

struct ContentView: View {
  let dependancyContainer = DependancyContainer()
  let coordinator = MainCoordidnator()
  var body: some View {
    NavigationView {
      BookListView()
        .environmentObject(coordinator)
        .environmentObject(dependancyContainer.bookListViewConfiguration)
    }
  }
}
