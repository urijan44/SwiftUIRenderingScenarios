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
  
  enum NavigationRoot {
    case bookDetail(book: Binding<Book>)
    case none
  }
  
  @EnvironmentObject var dependancyObject: DependancyContainer
  @EnvironmentObject var dataModel: ViewModel
  @State var root: NavigationRoot = .none
  @State var navigationTrigger = false
  var body: some View {
    ScrollView {
      VStack {
        navigationLinkSection()
        ForEach($dataModel.books, id: \.id) { book in
          BookListCell(book: book)
            .environmentObject(dataModel)
            .onTapGesture {
              root = .bookDetail(book: book)
              DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                navigationTrigger.toggle()
              }
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
  
  @ViewBuilder
  func navigationLinkSection() -> some View {
    switch root {
    case .none:
      EmptyView()
    case .bookDetail(let book):
      NavigationLink(isActive: $navigationTrigger) {
        BookDetailView(book: book)
          .environmentObject(dependancyObject.bookDetailViewConfiguration)
      } label: {
        EmptyView()
      }
    }
  }
}



struct SotwithDDPreview: PreviewProvider {
  static var previews: some View {
    BookListView()
  }
}
