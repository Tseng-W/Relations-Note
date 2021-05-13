//
//  EventViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation
import Firebase

class EventViewModel: BaseProvider {

  static let shared = EventViewModel()

  let events: Box<[Event]?> = Box(nil)

  let mockEvent = Event(id: nil, type: EventCategory(type: .deal, category: Category(title: "cT", imageData: "ciD", isCustom: true, subData: [SubCategory(title: "sT", imageData: "siD", isCustom: true, description: "sD")], description: "cD")), owner: -1, relations: ["blea4enJDRoW7x7kdoT1"], interval: Timestamp(date: Date()), occurTime: Timestamp(date: Date()))

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
    events.value?.append(event)
  }

  func onEventModified(event: Event) {
    events.value?[(events.value?.firstIndex(where: { $0.id == event.id }))!] = event
  }

  func onEventDeleted(event: Event) {
    events.value?.remove(at: (events.value?.firstIndex(where: { $0.id == event.id }))!)
  }
}
