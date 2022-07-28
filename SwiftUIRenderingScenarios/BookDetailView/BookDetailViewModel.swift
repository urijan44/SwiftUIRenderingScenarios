//
//  BookDetailViewModel.swift
//  SwiftUIRenderingScenarios
//
//  Created by leehs81 on 2022/07/28.
//

import SwiftUI

extension BookDetailView {
  final class ViewModel: ObservableObject {
    let repository: BookListRepository
    
    init(repository: BookListRepository) {
      self.repository = repository
    }

    func edit(book: Book) {
      repository.updateBook(book: book)
    }
  }
}
