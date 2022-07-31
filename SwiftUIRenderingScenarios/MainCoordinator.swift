//
//  MainCoordinator.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/08/01.
//

import SwiftUI
import Combine

extension Notification.Name {
  static let popToRoot = Notification.Name("PopToRoot")
}

final class MainCoordidnator: ObservableObject {
  private let diContainer = DependancyContainer()

  enum Destination {
    case bookList
    case bookDetail(book: Binding<Book>)
    case cart
  }

  private var destination: Destination = .bookList
  private var isRoot: Bool
  private var cancellables = Set<AnyCancellable>()
  @Published var rootTrigger = false
  @Published var linkTrigger = false

  init(isRoot: Bool = false) {
    self.isRoot = isRoot

    NotificationCenter.default.publisher(for: .popToRoot)
      .sink { [weak self] _ in
        guard let self = self else { return }
        self.rootTrigger = false
      }
      .store(in: &cancellables)
  }

  @ViewBuilder
  func navigationLinkSection() -> some View {
    NavigationLink(
      isActive: .init(
        get: { [unowned self] in
          if isRoot {
            return rootTrigger
          } else {
            return linkTrigger
          }
        },
        set: { [unowned self] newTrigger in
          if isRoot {
            rootTrigger = newTrigger
          } else {
            linkTrigger = newTrigger
          }
          print(isRoot)
        }
      )
    ) {
      switch destination {
        case .bookList:
          BookListView()
            .environmentObject(diContainer.bookListViewConfiguration)
        case .bookDetail(let book):
          BookDetailView(book: book)
            .environmentObject(diContainer.bookDetailViewConfiguration)
        case .cart:
          BookmarkListView()
            .environmentObject(diContainer.bookmarkListViewConfiguration)
      }
    } label: {
      EmptyView()
    }
    .isDetailLink(false)
  }

  func popToRootView() {
    NotificationCenter.default.post(name: .popToRoot, object: nil)
  }

  func start() {
    destination = .bookList
    toggleLink()
  }

  func showBookDetailView(book: Binding<Book>) {
    destination = .bookDetail(book: book)
    toggleLink()
  }

  func showCart() {
    destination = .cart
    toggleLink()
  }


  private func toggleLink() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [unowned self] in
      if isRoot {
        rootTrigger.toggle()
      } else {
        linkTrigger.toggle()
      }
    }
  }
}

final class DependancyContainer: ObservableObject {
  let repository = BookListRepository.shared
  lazy var bookListViewConfiguration = makeBookListViewConfiguration()
  lazy var bookDetailViewConfiguration = makeBookDetailViewConfiguration()
  lazy var bookmarkListViewConfiguration = makeBookmarkListViewConfiguration()

  private func makeBookListViewConfiguration() -> BookListView.DataModel {
    let viewModel = BookListView.DataModel(repository: repository)
    return viewModel
  }

  private func makeBookDetailViewConfiguration() -> BookDetailView.DataModel {
    let viewModel = BookDetailView.DataModel(repository: repository)
    return viewModel
  }

  private func makeBookmarkListViewConfiguration() -> BookmarkListView.DataModel {
    let viewModel = BookmarkListView.DataModel(repository: repository)
    return viewModel
  }
}

