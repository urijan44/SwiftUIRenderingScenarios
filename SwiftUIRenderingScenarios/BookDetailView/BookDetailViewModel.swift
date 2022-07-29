//
//  BookDetailViewModel.swift
//  SwiftUIRenderingScenarios
//
//  Created by leehs81 on 2022/07/28.
//

import SwiftUI
import Combine

extension BookDetailView {
  final class ViewModel: ObservableObject {
    @Published var book: Book = Book(imageURL: "", title: "", author: "", isBookmarked: false)
    private let repository: BookListRepository
    private var cancellable: Set<AnyCancellable> = []
    
    init(repository: BookListRepository) {
      self.repository = repository
      
      $book
        .filter{ !$0.title.isEmpty }
        .sink { [unowned self] newBook in
          edit(book: newBook)
        }
        .store(in: &cancellable)
    }
    
    func toogleBookmark() {
      book.isBookmarked.toggle()
    }

    func edit(book: Book) {
      repository.updateBook(book: book)
    }
    
    func fetchBook(book: Book) {
      self.book = book
    }
  }
}
