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
  @DocumentID var docId: String?
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
}

extension Event {
  static func getEmptyEvent() -> Event {
    return Event(owner: .empty, relations: [], imageLink: .empty, mood: 0, category: Category(), time: Timestamp(), subEvents: [], comment: .empty)
  }

  func isInitialed() -> Bool {
    return !owner.isEmpty && !relations.isEmpty && category.isInitialed()
  }

  func getRelationImage(completion: @escaping (UIImage?) -> Void) {
    category.getImage{ completion($0) }
  }

  func getColor() -> UIColor {
    return category.getColor()
  }

  func toDict() -> [AnyHashable: Any] {
    var dic = ["owner": owner,
            "relations": relations,
            "mood": mood,
            "category": category.toDict(),
            "time": time,
            "subEvents": subEvents] as [String : Any]

    if let imageLink = imageLink {
      dic["imageLink"] = imageLink
    }

    if let location = location,
       let locationName = locationName {
      dic["location"] = location
      dic["locationName"] = locationName
    }

    if let comment = comment {
      dic["comment"] = comment
    }

    return dic
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
