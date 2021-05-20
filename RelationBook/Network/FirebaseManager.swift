//
//  FirebaseManager.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import Foundation
import Firebase
//import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseManager {

  static let shared = FirebaseManager()

  let db = Firestore.firestore()

  let relationViewModel = RelationViewModel()

  let eventViewModel = EventViewModel()

  func fetchRelationsMock(userID: Int) {
    db.collection(Collections.relation.rawValue).whereField("owner", isEqualTo: userID).addSnapshotListener { snapShot, error in

      if let error = error { print(error) }

      snapShot?.documentChanges.forEach({ diff in
        guard let relation = try? diff.document.data(as: Relation.self) else { return }
        switch diff.type {
        case .added:
          self.relationViewModel.onRelationAdded(relation: relation)
        case.modified:
          self.relationViewModel.onRelationModified(relation: relation)
        case.removed:
          self.relationViewModel.onRelationDeleted(relation: relation)
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
          self.eventViewModel.onEventAdded(event: event)
        case.modified:
          self.eventViewModel.onEventModified(event: event)
        case.removed:
          self.eventViewModel.onEventDeleted(event: event)
        }
      })
    }
  }

  func addRelation(userID: Int, data: Relation) {
    _ = try? db.collection(Collections.relation.rawValue).addDocument(from: data) { error in
      if let error = error { print(error) }
    }
  }

  func addEvent(userID: Int, data: Event, completion: @escaping (Result<String, Error>) -> Void = {_ in }) {
    let newEvent = try? db.collection(Collections.event.rawValue).addDocument(from: data) { error in
      if let error = error { completion(.failure(error)) }
    }

    completion(.success(newEvent!.documentID))
  }

  func fetchUser(appleID: String, completion: @escaping (Result<User?, Error>) -> Void) {
    let docRef = db.collection(Collections.user.rawValue).whereField("appleID", in: [appleID])

    docRef.getDocuments { snapshot, error in
      if let error = error {
        print("Error getting document: \(error.localizedDescription)")
        completion(.failure(error))
      } else {
        let user = snapshot?.documents.compactMap { document in
          try? document.data(as: User.self)
        }.first
        completion(.success(user))
      }
    }
  }

  func addUser(user: inout User) {
    let document = db.collection(Collections.user.rawValue).document()
    try? document.setData(from: user) { error in
      if let error = error {
        print("Set data error \(error.localizedDescription)")
      }
    }
  }
}
