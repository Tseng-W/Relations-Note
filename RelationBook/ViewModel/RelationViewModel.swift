//
//  FillterViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/10.
//

import UIKit
import Firebase

class RelationViewModel: BaseProvider {

  let userViewModel = UserViewModel()

  var relations = Box([Relation]())

  var mockRelations: [Relation] = []

  func fetchRelations(id userID: Int) {
    FirebaseManager.shared.fetchRelationsMock(userID: userID)
  }

  func addRelation(id userID: Int, relation: Relation) {
    FirebaseManager.shared.addRelation(userID: userID, data: relation)
  }

  func onRelationAdded(relation: Relation) {
    relations.value.append(relation)
  }

  func onRelationModified(relation: Relation) {
    relations.value[(relations.value.firstIndex(where: { $0.id == relation.id }))!] = relation
  }

  func onRelationDeleted(relation: Relation) {
    relations.value.remove(at: (relations.value.firstIndex(where: { $0.id == relation.id }))!)
  }

  func getCategories() -> [Category] {
    let categories: [Category] = []
    return categories
  }

  func fetchMockData() {
    let count = userViewModel.mockRelationSubCategory.count
    for index in 0..<count {
      let newRelation = Relation(id: "mock", isPublic: false, categoryIndex: index, owner: -1, feature: [0: ""], createdTime: Timestamp(date: Date()), lastContactTime: Timestamp(date: Date()))
      relations.value.append(newRelation)
    }
  }
}
