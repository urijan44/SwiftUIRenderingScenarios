//
//  SotwithDD.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/03.
//

import SwiftUI
import Combine

struct BookListView: View {
  @StateObject var coordinator = MainCoordidnator(isRoot: true)
  @EnvironmentObject var dataModel: DataModel
  var body: some View {
    ScrollView {
      VStack {
        coordinator.navigationLinkSection()
        ForEach($dataModel.books, id: \.id) { book in
          BookListCell<DataModel>(book: book)
            .environmentObject(dataModel)
            .onTapGesture {
              coordinator.showBookDetailView(book: book)
            }
        }
      }
      .animation(.easeIn(duration: 0.3), value: dataModel.books)
      .searchable(text: $dataModel.searchText)
      .navigationTitle("Books")
      .navigationBarTitleDisplayMode(.large)
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
    }
    .onAppear {
      dataModel.fetch()
    }
  }
}

struct SotwithDDPreview: PreviewProvider {
  static var previews: some View {
    BookListView()
  }
}
