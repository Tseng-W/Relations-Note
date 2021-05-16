//
//  EventViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation
import Firebase

class EventViewModel: BaseProvider {

  let value: Box<[Event]?> = Box(nil)

  let mockEvent = Event(id: "mockEvent",
                        type: .deal,
                        categoryIndex: 0,
                        owner: -1,
                        relations: ["mockRelation"],
                        interval: Timestamp(date: Date()),
                        occurTime: Timestamp(date: Date()))

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
    value.value?.append(event)
  }

  func onEventModified(event: Event) {
    value.value?[(value.value?.firstIndex(where: { $0.id == event.id }))!] = event
  }

  func onEventDeleted(event: Event) {
    value.value?.remove(at: (value.value?.firstIndex(where: { $0.id == event.id }))!)
  }
}
