//
//  BookDetailView.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/04.
//

import SwiftUI
import Combine

struct BookDetailView: View {
  enum Field: Hashable {
         case review
  }
  @StateObject var viewModel = ViewModel()
  @FocusState private var focus: Field?

  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Image(viewModel.book.imageURL)
          .resizable()
          .aspectRatio(nil ,contentMode: .fit)
          .frame(height: UIScreen.main.bounds.height * 0.4)
          .overlay(
            Button(action: {
              viewModel.setBookmark()
            }, label: {
              Image(systemName: viewModel.book.isBookmarked ? "bookmark.fill" : "bookmark")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.yellow)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity,  alignment: .bottomTrailing)

          )
        Text(viewModel.book.title)
          .font(.body)
        Text(viewModel.book.author)
          .font(.caption)
          .foregroundColor(.gray)
      }
      .padding()
      .background(
        RoundedRectangle(cornerRadius: 8)
          .stroke()
          .shadow(radius: 5)
      )
      Text("리뷰 작성")
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
      TextEditor(text: $viewModel.book.review)
        .frame(height: 250)
        .focused($focus, equals: .review)
    }
    .padding(.horizontal)
    .onAppear {
      focus = .review
    }
  }

  init() {
    print("detail view init")
  }
}

extension BookDetailView {
  final class ViewModel: ObservableObject {
    private let appState = AppState.shared
    @Published var book: Book = Book(imageURL: "", title: "", author: "", isBookmarked: false)
    private var cancellables = Set<AnyCancellable>()

    init() {
      fetch()
    }

    func fetch() {
      book = appState.books[appState.currentBookIndex]

      self.$book
        .map(\.review)
        .sink(receiveValue: setReview(review:))
        .store(in: &cancellables)
    }

    func setBookmark() {
      book.isBookmarked.toggle()
      appState.updateBook(book: book)
    }

    func setReview(review: String) {
      appState.updateBook(book: book)
    }
  }
}
