//
//  RelationObject.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Relation: Codable {
  @DocumentID var id: String?
  var isPublic: Bool
  var categoryIndex: Int
  var owner: Int
  var feature: [Int: String]
  var createdTime: Timestamp
  var lastContactTime: Timestamp
}
