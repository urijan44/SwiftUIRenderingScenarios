//
//  BookmarkListView.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/08/01.
//

import SwiftUI

struct BookmarkListView: View {
  @StateObject var coordinator = MainCoordidnator()
  @EnvironmentObject var dataModel: DataModel
  var body: some View {
    ScrollView {
      coordinator.navigationLinkSection()
      LazyVStack {
        ForEach($dataModel.bookmarkedBooks) { book in
          BookListCell<DataModel>(book: book)
            .environmentObject(dataModel)
            .onTapGesture {
              coordinator.showBookDetailView(book: book)
            }
        }
      }
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            coordinator.showCart()
          } label: {
            Image(systemName: "bookmark.fill")
              .foregroundColor(.black)
          }
        }
        ToolbarItem(placement: .navigationBarTrailing) {
          Button {
            coordinator.popToRootView()
          } label: {
            Image(systemName: "house.fill")
              .foregroundColor(.black)
          }
        }
      }
    }
    .onAppear {
      dataModel.fetchBook()
    }
  }
}

extension BookmarkListView {
  final class DataModel: ObservableObject, Bookmarkable {
    private let repository: BookListRepositoryInterface

    @Published var bookmarkedBooks: [Book] = []
    init(repository: BookListRepositoryInterface) {
      self.repository = repository
    }

    func setBookmark(book: Book) {
      repository.updateBook(book: book)
    }


    func fetchBook() {
      let bookmarklist = repository.fetchBook(keyword: "")
        .filter { $0.isBookmarked }
      bookmarkedBooks = bookmarklist
    }
  }

}
