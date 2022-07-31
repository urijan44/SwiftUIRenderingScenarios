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
  
  init(imageURL: String, title: String, author: String, isBookmarked: Bool, review: String = "") {
    self.imageURL = imageURL
    self.title = title
    self.author = author
    self.isBookmarked = isBookmarked
    self.review = review
  }

  mutating
  func setBookmark(bookmark: Bool) {
    self.isBookmarked = bookmark
  }

  static func == (lhs: Book, rhs: Book) -> Bool {
    lhs.id == rhs.id
  }
}

extension Book: CustomStringConvertible {
  var description: String {
    "\(id), \(title), \(isBookmarked), \(review)"
  }
}
