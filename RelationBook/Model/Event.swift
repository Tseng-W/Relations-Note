//
//  EventObject.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

enum EventType: Int, Codable {
  case deal = 0
  case feature = 1
}

struct Event: Codable {
  @DocumentID var docID: String?
  var owner: String
  var relations: [Int]
  var mood: Category
  var event: Category
  var location: GeoPoint
  var locationName: String?
  var time: Timestamp
  var subEvents: [SubEvent]

  func getRelationImage() -> Category? {
    let userViewModel = UserViewModel()
    guard let relationID = relations.first,
          relationID < userViewModel.mockRelationSubCategory.count else { return nil }
    return userViewModel.mockRelationSubCategory[relationID]
  }
}

struct SubEvent: Codable {
  @DocumentID var id: String?
  var type: EventType
  var categoryIndex: Int
  var owner: Int?
  var relations: [String]?
  var interval: Timestamp?
  var occurTime: Timestamp?
}
