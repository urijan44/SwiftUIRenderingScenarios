//
//  SotwithDD.swift
//  SwiftUIRenderingScenarios
//
//  Created by hoseung Lee on 2022/07/03.
//

import SwiftUI
import Combine


//MARK: - View
struct BookListView: View {
  @EnvironmentObject var dependancyContainer: DependancyContainer
  @ObservedObject var dataModel: DataModel
  var body: some View {
    ScrollView {
      VStack {
        ForEach($dataModel.books, id: \.id) { book in
          NavigationLink {
            BookDetailView(book: book)
              .environmentObject(dependancyContainer)
          } label: {
            BookListCell(book: book)
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
}

