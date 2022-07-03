//
//  SotwithDD.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/03.
//

import SwiftUI
import Combine

//MARK: - Model
struct Book: Hashable, Identifiable {
  let id = UUID().uuidString
  let imageURL: String
  let title: String
  let author: String
  var isBookmarked: Bool

  mutating
  func setBookmark(bookmark: Bool) {
    self.isBookmarked = bookmark
  }
}

//MARK: - View
struct BookListView: View {
  @StateObject var dataModel = ViewModel()
  var body: some View {
    ScrollView {
      LazyVStack {
        ForEach($dataModel.filteredBooks, id: \.id) { book in
          BookListCell(book: book)
            .environmentObject(dataModel)
            .transition(.opacity)
        }
      }
      .animation(.easeIn(duration: 0.3), value: dataModel.filteredBooks)
      .searchable(text: $dataModel.searchText)
      .navigationTitle("Books")
      .navigationBarTitleDisplayMode(.large)
    }
  }
}

struct SotwithDDPreview: PreviewProvider {
  static var previews: some View {
    BookListView()
  }
}

extension BookListView {
  final class ViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var filteredBooks: [Book] = []
    @Published var searchText = ""
    private var cancellables = Set<AnyCancellable>()
    init() {
      books = [
        Book(imageURL: "book1", title: "파친코", author: "이민진", isBookmarked: false),
        Book(imageURL: "book2", title: "돈, 뜨겁게 사랑하고 차갑게 다루어라", author: "앙드레 코스톨라니", isBookmarked: false),
        Book(imageURL: "book3", title: "달러구트 꿈 백화점", author: "이미예", isBookmarked: false),
        Book(imageURL: "book4", title: "오은영의 화해", author: "오은영", isBookmarked: false),
      ]

      filteredBooks = books

      $books
        .sink { [unowned self] books in
          print("books chanhged")
        }
        .store(in: &cancellables)

      $searchText
        .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
        .map { [unowned self] keyword -> [Book] in
          let filtered = books.filter { book in
            return book.title.hasPrefix(keyword) || book.author.hasPrefix(keyword)
          }
          return filtered
        }
        .sink { [unowned self] books in
            self.filteredBooks = books
        }
        .store(in: &cancellables)
    }

    func setBookmark(book: Book) {
      guard let index = books.firstIndex(of: book) else { return }
      books[index].isBookmarked.toggle()

    }
  }
}

struct BookListCell: View {
  @Binding var book: Book
  var body: some View {
    HStack(alignment: .top) {
      Image(book.imageURL)
        .resizable()
        .aspectRatio(nil, contentMode: .fill)
        .frame(width: 150)
        .shadow(radius: 4)
      VStack(alignment: .leading) {
        Text(book.title)
          .font(.body)
          .fontWeight(.bold)
        Text(book.author)
          .font(.caption)
          .foregroundColor(.gray)
      }
      Spacer()
      Button {
        book.isBookmarked.toggle()
      } label: {
        Image(systemName: book.isBookmarked ? "bookmark.fill" : "bookmark")
          .foregroundColor(.yellow)
          .font(.title)
      }
      .padding(.horizontal, 6)
    }
    .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
  }

  init(book: Binding<Book>) {
    self._book = book
  }
}
