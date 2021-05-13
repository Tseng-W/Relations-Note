//
//  RelationObject.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct RelationCategory: Codable {
  var isPublic: Bool
  var category: Category
}

struct Relation: Codable {
  @DocumentID var id: String?
  var type: RelationCategory
  var owner: Int
  var feature: [Category]
  var createdTime: Timestamp
  var lastContactTime: Timestamp
}
