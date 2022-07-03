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
  var review = ""

  mutating
  func setBookmark(bookmark: Bool) {
    self.isBookmarked = bookmark
  }

  static func == (lhs: Book, rhs: Book) -> Bool {
    lhs.id == rhs.id
  }
}

//MARK: - View
struct BookListView: View {
  @StateObject var dataModel = ViewModel()
  @State var navigationTrigger = false
  var body: some View {
    ScrollView {
      VStack {
        navigationLinkSection()
        ForEach($dataModel.books, id: \.id) { book in
          Button {
            showDetailView(book: book.wrappedValue)
          } label: {
            BookListCell(book: book)
              .transition(.opacity)
              .environmentObject(dataModel)
          }
        }
      }
      .animation(.easeIn(duration: 0.3), value: dataModel.books)
      .searchable(text: $dataModel.searchText)
      .navigationTitle("Books")
      .navigationBarTitleDisplayMode(.large)
    }
    .onAppear {
      dataModel.fetch()
    }
  }

  func navigationLinkSection() -> some View {
    NavigationLink(isActive: $navigationTrigger) {
      BookDetailView()
    } label: {
      EmptyView()
    }
  }

  func showDetailView(book: Book) {
    dataModel.showDetailView(book: book)
    navigationTrigger.toggle()
  }
}

struct SotwithDDPreview: PreviewProvider {
  static var previews: some View {
    BookListView()
  }
}

extension BookListView {
  final class ViewModel: ObservableObject {
    private let appState = AppState.shared
    @Published var books: [Book] = []
    @Published var searchText = ""
    private var cancellables = Set<AnyCancellable>()
    init() {
    }

    func fetch() {
      books = appState.books
    }

    func setBookmark(book: Book) {
      guard let index = appState.books.firstIndex(of: book) else { return }
      appState.books[index].isBookmarked.toggle()
    }

    func showDetailView(book: Book) {
      appState.prepareEditingDetail(book: book)
    }
  }
}

struct BookListCell: View {
  @EnvironmentObject var viewModel: BookListView.ViewModel
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
        Text(book.review)
          .font(.footnote)
          .foregroundColor(.primary)
      }
      Spacer()
      Button {
        viewModel.setBookmark(book: book)
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
