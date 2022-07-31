//
//  SwiftUIRenderingScenariosApp.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/03.
//

import SwiftUI

@main
struct SwiftUIRenderingScenariosApp: App {
  let dependancyContainer = DependancyContainer()
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(dependancyContainer)
    }
  }
}

final class DependancyContainer: ObservableObject {
  let repository = BookListRepository()
  lazy var bookListViewConfiguration: BookListView.DataModel = makeBookListViewConfiguration()
  lazy var bookDetailViewConfiguration = makeBookDetailViewConfiguration()
  
  private func makeBookListViewConfiguration() -> BookListView.DataModel {
    let viewModel = BookListView.DataModel(repository: repository)
    return viewModel
  }
  
  private func makeBookDetailViewConfiguration() -> BookDetailView.DataModel {
    let viewModel = BookDetailView.DataModel(repository: repository)
    return viewModel
  }
}

