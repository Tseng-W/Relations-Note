//
//  FirebaseManager.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FirebaseManager {

  static let shared = FirebaseManager()

  let db = Firestore.firestore()

  func fetchRelationsMock(userID: Int) {
    db.collection(Collections.relation.rawValue).whereField("owner", isEqualTo: userID).addSnapshotListener { snapShot, error in

      if let error = error { print(error) }

      snapShot?.documentChanges.forEach({ diff in
        guard let relation = try? diff.document.data(as: Relation.self) else { return }
        switch diff.type {
          case .added:
            RelationViewModel.shared.onRelationAdded(relation: relation)
          case.modified:
            RelationViewModel.shared.onRelationModified(relation: relation)
          case.removed:
            RelationViewModel.shared.onRelationDeleted(relation: relation)
        }
      })
    }
  }

  func fetchEventsMock(userID: Int) {
    db.collection(Collections.event.rawValue).whereField("owner", isEqualTo: userID).addSnapshotListener { snapShot, error in

      if let error = error { print(error) }

      snapShot?.documentChanges.forEach({ diff in
        guard let event = try? diff.document.data(as: Event.self) else { return }
        switch diff.type {
          case .added:
            EventViewModel.shared.onEventAdded(event: event)
          case.modified:
            EventViewModel.shared.onEventModified(event: event)
          case.removed:
            EventViewModel.shared.onEventDeleted(event: event)
        }
      })
    }
  }

  func addRelation(userID: Int, data: Relation) {
    _ = try? db.collection(Collections.relation.rawValue).addDocument(from: data) { error in
      if let error = error { print(error) }
    }
  }

  func addEvent(userID: Int, data: Event) {
    _ = try? db.collection(Collections.event.rawValue).addDocument(from: data) { error in
      if let error = error { print(error) }
    }
  }
}
