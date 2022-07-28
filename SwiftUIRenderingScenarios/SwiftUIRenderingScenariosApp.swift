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
  lazy var bookListViewConfiguration: BookListView.ViewModel = makeBookListViewConfiguration()
  lazy var bookDetailViewConfiguration = makeBookDetailViewConfiguration()
  
  private func makeBookListViewConfiguration() -> BookListView.ViewModel {
    let viewModel = BookListView.ViewModel(repository: repository)
    return viewModel
  }
  
  private func makeBookDetailViewConfiguration() -> BookDetailView.ViewModel {
    let viewModel = BookDetailView.ViewModel(repository: repository)
    return viewModel
  }
}

