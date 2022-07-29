//
//  BookDetailViewModel.swift
//  SwiftUIRenderingScenarios
//
//  Created by leehs81 on 2022/07/28.
//

import SwiftUI
import Combine

extension BookDetailView {
  final class DataModel: ObservableObject {
    @Published var book: Book = Book(imageURL: "noImage", title: "", author: "", isBookmarked: false)
    var title: String {
      book.title
    }
    
    var review: String {
      get {
        book.review
      }
      set {
        book.review = newValue
      }
    }
    
    var author: String {
      book.author
    }
    
    var isBookmarked: Bool {
      book.isBookmarked
    }
    
    var imageURL: String {
      book.imageURL
    }
    
    private let repository: BookListRepository
    private var cancellable: Set<AnyCancellable> = []
    
    init(repository: BookListRepository) {
      self.repository = repository
    }
    
    func toogleBookmark() {
      book.isBookmarked.toggle()
      edit(book: book)
    }
    
    func setReview() {
      edit(book: book)
    }

    private func edit(book: Book) {
      repository.updateBook(book: book)
    }
    
    func fetchBook(book: Book) {
      self.book = book
    }
  }
}
