//
//  BookListViewModel.swift
//  SwiftUIRenderingScenarios
//
//  Created by leehs81 on 2022/07/28.
//

import SwiftUI
import Combine

extension BookListView {
  final class ViewModel: ObservableObject {
    private let repository: BookListRepository
    @Published var books: [Book] = []
    @Published var searchText = ""
    private var cancellables = Set<AnyCancellable>()
    init(repository: BookListRepository) {
      self.repository = repository
      $searchText
        .removeDuplicates()
        .map { [unowned self] word in
          self.repository.fetchBook(keyword: word)
        }
        .assign(to: &$books)
      
    }

    func fetch() {
      books = repository.fetchBook(keyword: "")
    }

    func setBookmark(book: Book) {
      repository.updateBook(book: book)
    }
  }
}
