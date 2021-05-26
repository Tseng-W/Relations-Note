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
  var feature: [Feature]
  var createdTime: Timestamp
  var lastContactTime: Timestamp
}

struct Feature: Codable {

  init(id: String, index: Int, data: [FeatureContent]) {
    relationID = id
    categoryIndex = index
    contents = data
  }

  var relationID: String
  var categoryIndex: Int
  var contents: [FeatureContent]
}

struct FeatureContent: Codable {
  var isProcessing: Bool
  var content: String
}
