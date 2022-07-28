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
  @EnvironmentObject var dependancyObject: DependancyContainer
  @EnvironmentObject var dataModel: ViewModel
  @State var navigationTrigger = false
  var body: some View {
    ScrollView {
      VStack {
        ForEach($dataModel.books, id: \.id) { book in
          NavigationLink {
            BookDetailView(book: book)
              .environmentObject(dependancyObject.bookDetailViewConfiguration)
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
      print("onAppear")
      dataModel.fetch()
    }
  }
}

struct SotwithDDPreview: PreviewProvider {
  static var previews: some View {
    BookListView()
  }
}
