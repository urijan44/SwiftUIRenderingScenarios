//
//  BookDetailView.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/04.
//

import SwiftUI

struct BookDetailView: View {
  enum Field: Hashable {
         case review
  }
  @Binding var book: Book
  @FocusState private var focus: Field?

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
      TextEditor(text: $book.review)
        .frame(height: 250)
        .focused($focus, equals: .review)
    }
    .padding(.horizontal)
    .onAppear {
      focus = .review
    }
  }

  init(book: Binding<Book>) {
    self._book = book
    print(book.wrappedValue.title, "detail view init")
  }
}

//struct BookDetailView_Previews: PreviewProvider {
//  static var previews: some View {
//    BookDetailView(book: .constant(Book(imageURL: "book1", title: "파친코", author: "이민진", isBookmarked: false)))
//  }
//}
