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
    
    // MARK: Properties
    private let repository: BookRepositoryInterface
    
    @Published var books: [Book] = []
    @Published var searchText = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: Methods
    init(repository: BookRepositoryInterface) {
      self.repository = repository
      bind()
    }
    
    private func bind() {
      $searchText
        .debounce(for: 0.5, scheduler: DispatchQueue.main)
        .removeDuplicates()
        .map { [unowned self] word in
          repository.fetchBook(keyword: word)
        }
        .assign(to: &$books)
    }

    func fetch() {
      books = repository.fetchBook(keyword: searchText)
    }

    func updateBook(book: Book) {
      repository.updateBook(book: book)
    }
  }
}



