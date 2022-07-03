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
struct SotwithDD: View {
  @StateObject var dataModel = ViewModel()
  var body: some View {
    ScrollView {
      LazyVStack {
        ViewInitTracker()
        ForEach(dataModel.books, id: \.id) { book in
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
              dataModel.setBookmark(book: book)
            } label: {
              Image(systemName: book.isBookmarked ? "bookmark.fill" : "bookmark")
                .foregroundColor(.yellow)
                .font(.title)
            }
            .padding(.horizontal, 6)
          }
          .padding(EdgeInsets(top: 6, leading: 6, bottom: 6, trailing: 6))
        }
      }
    }
  }
}

struct ViewInitTracker: View {
  var body: some View {
    EmptyView()
  }

  init() {
    print("View init")
  }
}

struct SotwithDDPreview: PreviewProvider {
  static var previews: some View {
    SotwithDD()
  }
}

extension SotwithDD {
  final class ViewModel: ObservableObject {
    @Published var someState: Bool = false
    @Published var books: [Book] = []

    init() {
      books = [
        Book(imageURL: "book1", title: "파친코", author: "이민진", isBookmarked: false),
        Book(imageURL: "book2", title: "돈, 뜨겁게 사랑하고 차갑게 다루어라", author: "앙드레 코스톨라니", isBookmarked: false),
        Book(imageURL: "book3", title: "달러구트 꿈 백화점", author: "이미예", isBookmarked: false),
        Book(imageURL: "book4", title: "오은영의 화해", author: "오은영", isBookmarked: false),
      ]
    }

    func setBookmark(book: Book) {
      guard let index = books.firstIndex(of: book) else { return }
      books[index].setBookmark(bookmark: !book.isBookmarked)
    }
  }
}
