//
//  EventViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation
import Firebase

class EventViewModel {

  let events = Box([Event]())

  func addEvent(event: Event, completion: @escaping ((Result<String, Error>) -> Void)) {

    FirebaseManager.shared.addEvent(data: event) { result in
      switch result {
      case .success(let docID):
        completion(.success(docID))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func fetchEvents() {
    guard let uid = UserDefaults.standard.getString(key: .uid) else { return }
    FirebaseManager.shared.events.bind { [weak self] events in
      self?.events.value = events
    }

    FirebaseManager.shared.fetchEvents(uid: uid)
  }

  func getCategories() -> [Category] {
    let categories: [Category] = []
    return categories
  }

  func onEventAdded(event: Event) {
    events.value.append(event)
  }

  func onEventModified(event: Event) {
    events.value[(events.value.firstIndex(where: { $0.docID == event.docID }))!] = event
  }

  func onEventDeleted(event: Event) {
    events.value.remove(at: (events.value.firstIndex(where: { $0.docID == event.docID }))!)
  }
}
