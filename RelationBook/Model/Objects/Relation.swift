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
  var name: String
  var isPublic: Bool
  var categoryIndex: Int
  var owner: String
  var feature: [Feature]
  var createdTime: Timestamp
  var lastContactTime: Timestamp
}

struct Feature: Codable {

  init(id: Int, name: String, index: Int, data: [FeatureContent]) {
    self.name = name
    relationID = id
    categoryIndex = index
    contents = data
  }

  init() {
    self.init(id: -1, name: .empty, index: -1, data: [])
  }

  var name: String
  var relationID: Int
  var categoryIndex: Int
  var contents: [FeatureContent]
}

struct FeatureContent: Codable {
  var isProcessing: Bool
  var content: String
}
