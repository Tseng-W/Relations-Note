//
//  EventViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation
import Firebase

class EventViewModel {
  enum SortType {
    case date
  }

  var commentPlaceholder: String {
    get { return "備註" }
  }

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

  func updateEvent(event: Event) {
    FirebaseManager.shared.updateEvent(event: event)
  }

  func fetchEvents() {
    guard let uid = UserDefaults.standard.getString(key: .uid) else { return }

    FirebaseManager.shared.fetchEvents(uid: uid) { [weak self] events in
      self?.events.value = events
    }
  }

  func fetchEventIn(date: Date) -> [Event] {
    let events = events.value.filter { event in
      return date.isSameDay(date: event.time.dateValue())
    }

    return events
  }

  func fetchEventIn(relation: Category) -> [Event] {
    let events = events.value.filter { event in
      return event.relations.contains(relation.id)
    }

    return events
  }

  func getCategories() -> [Category] {
    let categories: [Category] = []
    return categories
  }

  func deleteEvent(event: Event) {
    FirebaseManager.shared.deleteEvent(event: event) { isSuccess in
      if isSuccess {
        LKProgressHUD.showSuccess(text: "刪除成功")
      } else {
        LKProgressHUD.showSuccess(text: "刪除失敗，請稍後再試")
      }
    }
  }

  func onEventAdded(event: Event) {
    events.value.append(event)
  }

  func onEventModified(event: Event) {
    guard let index = events.value.firstIndex(where: { $0.docId == event.docId }) else { return }
    events.value[index] = event
  }

  func onEventDeleted(event: Event) {
    guard let index = events.value.firstIndex(where: { $0.docId == event.docId }) else { return }
    events.value.remove(at: index)
  }
}
