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

  let mockEvent = Event(id: "-1",
                        relations: [
                          Category(id: 0, isCustom: false, superIndex: 0, title: "man", imageLink: "person.fill", backgroundColor: UIColor.systemRed.StringFromUIColor())
                        ],
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
    events.value[(events.value.firstIndex(where: { $0.id == event.id }))!] = event
  }

  func onEventDeleted(event: Event) {
    events.value.remove(at: (events.value.firstIndex(where: { $0.id == event.id }))!)
  }

  func postEvent(event: inout Event, completion: @escaping ((Result<Bool, Error>) -> Void)) {
    
  }

  func fetchMockEvent() {
    events.value.append(mockEvent)
  }
}
