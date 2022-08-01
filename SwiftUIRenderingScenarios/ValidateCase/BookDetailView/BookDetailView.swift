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
  @StateObject var coordinator = MainCoordidnator()
  @EnvironmentObject var dataModel: DataModel
  @FocusState private var focus: Field?
  @Binding var book: Book
  var body: some View {
    ScrollView {
      coordinator.navigationLinkSection()
      VStack(alignment: .leading) {
        Image(dataModel.imageURL)
          .resizable()
          .aspectRatio(nil ,contentMode: .fit)
          .frame(height: UIScreen.main.bounds.height * 0.4)
          .overlay(
            Button(action: {
              dataModel.toogleBookmark()
            }, label: {
              Image(systemName: dataModel.isBookmarked ? "bookmark.fill" : "bookmark")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.yellow)
            })
            .frame(maxWidth: .infinity, maxHeight: .infinity,  alignment: .bottomTrailing)

          )
        Text(dataModel.title)
          .font(.body)
        Text(dataModel.author)
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
      TextField("리뷰 작성", text: $dataModel.review)
        .onSubmit {
          dataModel.setReview()
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
    .padding(.horizontal)
    .onAppear {
      focus = .review
      dataModel.fetchBook(book: book)
    }
  }

  init(book: Binding<Book>) {
    self._book = book
  }
}
