//
//  FillterViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/10.
//

import UIKit
import Firebase

class RelationViewModel {

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
}
