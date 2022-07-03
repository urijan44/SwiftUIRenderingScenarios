//
//  ContentView.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/03.
//

import SwiftUI
import Combine

struct ContentView: View {
  var body: some View {
    NavigationView {
      Form {
        Section("Source of truth / Derived Data") {
          NavigationLink {
            BookListView()
          } label: {
            Text("Source of Truth / Derived Data")
          }
          NavigationLink {
            ViewInitCheck()
          } label: {
            Text("View init Check")
          }

        }
      }
    }
  }
}

final class AppState: ObservableObject {
  static let shared = AppState()
  @Published var books: [Book] = []
  @Published var currentBook: Book?
  private var cancellables = Set<AnyCancellable>()
  var currentBookIndex = 0

  private init() {
    books = [
      Book(imageURL: "book1", title: "파친코", author: "이민진", isBookmarked: false),
      Book(imageURL: "book2", title: "돈, 뜨겁게 사랑하고 차갑게 다루어라", author: "앙드레 코스톨라니", isBookmarked: false),
      Book(imageURL: "book3", title: "달러구트 꿈 백화점", author: "이미예", isBookmarked: false),
      Book(imageURL: "book4", title: "오은영의 화해", author: "오은영", isBookmarked: false),
    ]

    $currentBook
      .compactMap { $0 }
      .sink { [unowned self] book in
        books[currentBookIndex] = book
      }
      .store(in: &cancellables)
  }

  func prepareEditingDetail(book: Book) {
    guard let index = books.firstIndex(of: book) else { return }
    currentBookIndex = index
  }

  func updateBook(book: Book) {
    books[currentBookIndex] = book
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    Text("Hello, world!")
  }
}
