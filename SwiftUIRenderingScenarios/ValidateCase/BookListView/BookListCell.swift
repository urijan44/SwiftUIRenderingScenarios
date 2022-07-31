//
//  BookListCell.swift
//  SwiftUIRenderingScenarios
//
//  Created by leehs81 on 2022/07/28.
//

import SwiftUI

struct BookListCell: View {
  @EnvironmentObject var viewModel: BookListView.DataModel
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
          book.isBookmarked.toggle()
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
    print("book list cell init \(book.wrappedValue)")
  }
}
