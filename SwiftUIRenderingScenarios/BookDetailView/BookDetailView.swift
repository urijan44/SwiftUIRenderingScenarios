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
        Image(book.imageURL)
          .resizable()
          .aspectRatio(nil ,contentMode: .fit)
          .frame(height: UIScreen.main.bounds.height * 0.4)
          .overlay(
            Button(action: {
              book.isBookmarked.toggle()
              viewModel.edit(book: book)
            }, label: {
              Image(systemName: book.isBookmarked ? "bookmark.fill" : "bookmark")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.yellow)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity,  alignment: .bottomTrailing)

          )
        Text(book.title)
          .font(.body)
        Text(book.author)
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
      TextField("리뷰 작성", text: $book.review)
        .onSubmit {
          viewModel.edit(book: book)
        }
    }
    .padding(.horizontal)
    .onAppear {
      focus = .review
    }
  }

  init(book: Binding<Book>) {
    print("book detail view init\(book.wrappedValue.title)")
    self._book = book
  }
}
