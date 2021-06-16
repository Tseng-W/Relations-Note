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

extension Relation {
  func toDict() -> [AnyHashable: Any] {
    return ["name": name,
            "isPublic": isPublic,
            "categoryIndex": categoryIndex,
            "owner": owner,
            "feature": feature.map{ $0.toDict() },
            "createdTime": createdTime,
            "lastContactTime": lastContactTime]
  }
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

  func getContentDescription() -> String {

    if contents.isEmpty {
      return .empty
    } else if contents.count == 1 {
      return contents[0].text
    } else {
      return "\(contents[0].text) 等 \(contents.count) 項"
    }
  }

  func toDict() -> [String: Any] {
    return ["name": name,
            "relationID": relationID,
            "categoryIndex": categoryIndex,
            "contents": contents.map { $0.toDict() } ]
  }
}

struct FeatureContent: Codable {
  var isProcessing: Bool
  var text: String

  func toDict() -> [String: Any] {
    return ["isProcessing": isProcessing,
            "text": text]
  }
}
