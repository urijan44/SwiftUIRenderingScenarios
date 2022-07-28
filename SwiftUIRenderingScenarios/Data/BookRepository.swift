//
//  BookRepository.swift
//  SwiftUIRenderingScenarios
//
//  Created by leehs81 on 2022/07/28.
//

import Foundation
final class BookListRepository {
  private var booksMap: [String: Book] = [:] {
    didSet {
      print(booksMap.values.map(\.title), booksMap.values.map(\.review), booksMap.values.map(\.isBookmarked))
    }
  }
  
  init() {
    print("Repository")
    [
      Book(imageURL: "book1", title: "파친코", author: "이민진", isBookmarked: false),
      Book(imageURL: "book2", title: "돈, 뜨겁게 사랑하고 차갑게 다루어라", author: "앙드레 코스톨라니", isBookmarked: false),
      Book(imageURL: "book3", title: "달러구트 꿈 백화점", author: "이미예", isBookmarked: false),
      Book(imageURL: "book4", title: "오은영의 화해", author: "오은영", isBookmarked: false),
      Book(imageURL: "book5", title: "리팩터링 2판", author: "마틴 파울러", isBookmarked: false),
    ].forEach { book in
      booksMap.updateValue(book, forKey: book.id)
    }
  }
  
  func updateBook(book: Book) {
    booksMap.updateValue(book, forKey: book.id)
  }
  
  func fetchBook(keyword: String) -> [Book] {
    
    guard !keyword.isEmpty else { return Array(booksMap.values) }
    return booksMap.values.filter { book in
      book.title.contains(keyword)
    }
  }
}
