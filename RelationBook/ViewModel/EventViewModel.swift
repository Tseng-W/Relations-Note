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

  func fetchEvents(id userID: String) {
    FirebaseManager.shared.fetchEventsMock(userID: userID)
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
