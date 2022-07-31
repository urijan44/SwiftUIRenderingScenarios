//
//  MainCoordinator.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/08/01.
//

import SwiftUI
import Combine
import OrderedCollections

final class CoordinatorMap {
  static let shared = CoordinatorMap()
  private var triggers: OrderedDictionary<String, MainCoordidnator> = [:]
  private init() {}

  func push(coordinator: MainCoordidnator) {
    triggers.updateValue(coordinator, forKey: coordinator.id)
    print("PUSH", triggers.map(\.value))
  }

  func popToAll() {
    triggers.forEach { (_, coordinator) in
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak coordinator] in
        coordinator?.linkTrigger = false
      }
    }
    triggers.removeSubrange((1..<triggers.count))
    print(triggers)
  }

  func remove(coordinator: MainCoordidnator) {
    triggers.removeValue(forKey: coordinator.id)
  }
}

extension Notification.Name {
  static let popToRootView = Notification.Name("PopToRootView")
}

final class MainCoordidnator: ObservableObject {
  let id = UUID().uuidString
  private let diContainer = DependancyContainer()
  private let stack = CoordinatorMap.shared

  enum Destination {
    case bookList
    case bookDetail(book: Binding<Book>)
    case cart
  }

  private var destination: Destination = .bookList
  @Published var linkTrigger = false

  init() {
    stack.push(coordinator: self)
  }

  deinit {
    stack.remove(coordinator: self)
  }

  @ViewBuilder
  func navigationLinkSection() -> some View {
    NavigationLink(
      isActive: .init(
        get: { [unowned self] in
          linkTrigger
        },
        set: { [unowned self] newTrigger in
          linkTrigger = newTrigger
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
  }

  func popToRootView() {
    stack.popToAll()
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
      linkTrigger.toggle()
    }
  }
}

extension MainCoordidnator: Equatable, Hashable {
  static func == (lhs: MainCoordidnator, rhs: MainCoordidnator) -> Bool {
    lhs === rhs
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
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

