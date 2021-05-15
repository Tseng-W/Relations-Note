//
//  FillterViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/10.
//

import UIKit
import Firebase

class RelationViewModel: BaseProvider {

  static let shared = RelationViewModel()

  var value: Box<[Relation]?> = Box(nil)

  var mockRelation = Relation(id: "mockRelation",
                              isPublic: false,
                              categoryIndex: 1,
                              owner: -1,
                              feature: [0: "mockFeature"],
                              createdTime: Timestamp(date: Date()),
                              lastContactTime: Timestamp(date: Date()))

  func fetchRelations(id userID: Int) {
    FirebaseManager.shared.fetchRelationsMock(userID: userID)
  }

  func addRelation(id userID: Int, relation: Relation) {
    FirebaseManager.shared.addRelation(userID: userID, data: relation)
  }

  func onRelationAdded(relation: Relation) {
    value.value?.append(relation)
  }

  func onRelationModified(relation: Relation) {
    value.value?[(value.value?.firstIndex(where: { $0.id == relation.id }))!] = relation
  }

  func onRelationDeleted(relation: Relation) {
    value.value?.remove(at: (value.value?.firstIndex(where: { $0.id == relation.id }))!)
  }

  func getCategories() -> [Category] {
    let categories: [Category] = []
    return categories
  }
}
