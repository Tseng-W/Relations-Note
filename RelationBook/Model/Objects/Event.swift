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
  @DocumentID   var docID: String?
  var owner: String
  var relations: [Int]
  var imageLink: String?
  var mood: Int
  var category: Category
  var location: GeoPoint?
  var locationName: String?
  var time: Timestamp
  var subEvents: [SubEvent]
  var comment: String?

  func getRelationImage(completion: @escaping (UIImage?) -> Void) {
    category.getImage{ completion($0) }
  }

  func getColor() -> UIColor {
    return category.getColor()
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
