//
//  Book.swift
//  SwiftUIRenderingScenarios
//
//  Created by leehs81 on 2022/07/28.
//

import Foundation

//MARK: - Model
struct Book: Hashable, Identifiable {
  let id = UUID().uuidString
  let imageURL: String
  let title: String
  let author: String
  var isBookmarked: Bool
  var review = ""

  mutating
  func setBookmark(bookmark: Bool) {
    self.isBookmarked = bookmark
  }

  static func == (lhs: Book, rhs: Book) -> Bool {
    lhs.id == rhs.id
  }
}
