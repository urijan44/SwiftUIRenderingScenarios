//
//  BookListViewModel.swift
//  SwiftUIRenderingScenarios
//
//  Created by leehs81 on 2022/07/28.
//

import SwiftUI
import Combine

extension BookListView {
  final class DataModel: ObservableObject {
    private let repository: BookListRepository
    @Published var books: [Book] = []
    @Published var searchText = ""
    private var cancellables = Set<AnyCancellable>()
    init(repository: BookListRepository) {
      self.repository = repository
      $searchText
        .debounce(for: 0.5, scheduler: DispatchQueue.main)
        .removeDuplicates()
        .map { [unowned self] word in
          self.repository.fetchBook(keyword: word)
        }
        .assign(to: &$books)
    }

    func fetch() {
      books = repository.fetchBook(keyword: searchText)
    }

    func setBookmark(book: Book) {
      repository.updateBook(book: book)
    }
  }
}
