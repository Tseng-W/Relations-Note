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

  var userShared: Box<User?> = Box(nil)
  var relations = Box([Relation]())
  var events = Box([Event]())

  let db = Firestore.firestore()

  let relationViewModel = RelationViewModel()

  func fetchUser(completion: @escaping (User) -> Void = { _ in }) {

    if let user = userShared.value {
      completion(user)
      return
    }

    guard let uid = UserDefaults.standard.getString(key: .uid) else {
      print("Can't get firebase uid.")
      return
    }

    fetchUser(uid: uid) { result in
      switch result {
      case .success(let user):
        guard let user = user else {
          let email = UserDefaults.standard.getString(key: .email) ?? ""
          let newUser = User(uid: uid,
                             email: email)
          self.addUser(user: newUser)
          return
        }
        self.userShared.value = user
        completion(user)
      case .failure(let error):
        print("fetchUser error: \(error.localizedDescription)")
      }
    }
  }

  func fetchUser(uid: String, completion: @escaping (Result<User?, Error>) -> Void) {

    let docRef = db.collection(Collections.user.rawValue).document(uid)

    docRef.addSnapshotListener { document, error in
      if let document = document, document.exists {
        let user = try? document.data(as: User.self)
        completion(.success(user))
      } else {
        completion(.success(nil))
      }
    }
  }

  func addUser(user: User) {
    let document = db.collection(Collections.user.rawValue).document(user.uid!)
    try? document.setData(from: user) { error in
      if let error = error {
        print("Set data error \(error.localizedDescription)")
      }
    }
  }

  func addUserCategory(type: CategoryType, hierarchy: CategoryHierarchy, category: inout Category ,completion: @escaping ((Error?)->Void) = {_ in}) {

    guard let user = userShared.value else { return }

    let categories = type == .event ? user.eventSet :
      type == .feature ? user.featureSet : user.relationSet


    switch hierarchy {
    case .main:
      category.id = user.getFilter(type: type).count
      category.isSubEnable = type == .event ? false : true
      categories.main.append(category)
    case .sub:
      category.id = user.getCategoriesWithSuperIndex(type: type, filterIndex: category.superIndex).count
      category.isSubEnable = false
      categories.sub.append(category)
    }

    updateDocument(uid: user.uid!, dict: [categories.type.rawValue : categories.toDict()]) { error in
      if let error = error { completion(error); return}
    }
  }

  func fetchRelations(uid: String) {

    db.collection(Collections.relation.rawValue).whereField("owner", isEqualTo: uid).addSnapshotListener { snapShot, error in

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

  func fetchEvents(uid: String) {
    let docRef = db.collection(Collections.event.rawValue).whereField("owner", in: [uid])

    docRef.addSnapshotListener { snapShot, error in

      if let error = error { print(error) }

      snapShot?.documentChanges.forEach({ diff in
        guard let event = try? diff.document.data(as: Event.self) else { return }

        switch diff.type {
        case .added:
          if !self.events.value.contains(where: { $0.docID == event.docID }) {
            self.events.value.append(event)
          }
        case.modified:
          if let index = self.events.value.firstIndex(where: { $0.docID == event.docID }) {
            self.events.value[index] = event
          }
        case.removed:
          self.events.value.removeAll(where: { $0.docID == event.docID })
        }
      })
    }
  }

  func addRelation(userID: String, data: Relation, completion: @escaping ((String)->Void) = { _ in }) {
    let docRef = try? db.collection(Collections.relation.rawValue).addDocument(from: data) { error in
      if let error = error {
        print("addRelation error: \(error.localizedDescription)")
      }
    }

    guard let docID = docRef else { return }
    completion(docID.documentID)
  }

  func addEvent(data: Event, completion: @escaping (Result<String, Error>) -> Void = {_ in }) {
    let newEvent = try? db.collection(Collections.event.rawValue).addDocument(from: data) { error in
      if let error = error { completion(.failure(error)) }
    }

    completion(.success(newEvent!.documentID))
  }

  func updateDocument(uid: String, dict: [String: Any], completion: @escaping ((Error?)) -> Void) {

    let userDoc = db.collection(Collections.user.rawValue).document(uid)
    userDoc.updateData(dict) { error in
      if let error = error { completion(error) ; return }
      completion(nil)
    }
  }
}
