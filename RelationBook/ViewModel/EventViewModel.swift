//
//  EventViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation
import Firebase

class EventViewModel: BaseProvider {

  let events = Box([Event]())

  let mockEvent = Event(docID: "",
                        owner: "-1",
                        relations: [0],
                        mood: Category(id: 0, isCustom: false, superIndex: -1, title: "憤怒", imageLink: "face.smiling.fill", backgroundColor: UIColor.systemRed.StringFromUIColor()),
                        event: Category(id: 0, isCustom: false, superIndex: -1, title: "事件", imageLink: "", backgroundColor: ""),
                        location: GeoPoint(latitude: 0.0, longitude: 0.0),
                        locationName: "地球中心",
                        time: Timestamp(date: Date()),
                        subEvents: [])

  func addEvent(id userID: Int, event: Event) {
    FirebaseManager.shared.addEvent(userID: userID, data: event)
  }

  func fetchEvents(id userID: Int) {
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

  func postEvent(event: Event, completion: @escaping ((Result<String, Error>) -> Void)) {
    FirebaseManager.shared.addEvent(userID: -1, data: event) { result in
      switch result {
      case .success(let docID):
        completion(.success(docID))
      case .failure(let error):
        completion(.failure(error))
      }
    }
  }

  func fetchMockEvent() {
    events.value.append(mockEvent)
  }
}
