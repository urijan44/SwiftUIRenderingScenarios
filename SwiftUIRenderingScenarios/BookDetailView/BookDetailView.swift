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
  @EnvironmentObject var viewModel: ViewModel
  @FocusState private var focus: Field?
  @Binding var book: Book
  var body: some View {
    ScrollView {
      VStack(alignment: .leading) {
        Image(viewModel.book.imageURL)
          .resizable()
          .aspectRatio(nil ,contentMode: .fit)
          .frame(height: UIScreen.main.bounds.height * 0.4)
          .overlay(
            Button(action: {
              viewModel.toogleBookmark()
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
      TextField("리뷰 작성", text: $viewModel.book.review)
        .onSubmit {
          viewModel.setReview()
        }
    }
    .padding(.horizontal)
    .onAppear {
      focus = .review
      viewModel.fetchBook(book: book)
    }
  }

  init(book: Binding<Book>) {
    self._book = book
  }
}
