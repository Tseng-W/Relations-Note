//
//  FillterViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/10.
//

import UIKit
import Firebase

class RelationViewModel {

  static let shared = RelationViewModel()

  let userViewModel = UserViewModel.shared
  let eventViewModel = EventViewModel.shared

  var relations = Box([Relation]())

  func fetchRelations() {
    guard let userID = userViewModel.user.value?.docId! else { return }
    FirebaseManager.shared.fetchRelationsMock(userID: userID)
  }

  func addRelation(name: String, iconString: String, bgColor: UIColor, relationType: Category, feature: Feature) {

    guard let user = userViewModel.user.value else { return }

    let newIndex = user.getCategoriesWithSuperIndex(type: .relation, mainIndex: relationType.id).count

    let relation = Relation(
      id: nil,
      isPublic: false,
      categoryIndex: newIndex,
      owner: user.docId!,
      feature: [feature],
      createdTime: Timestamp(date: Date()),
      lastContactTime: Timestamp(date: Date()))

    FirebaseManager.shared.addRelation(userID: relation.owner, data: relation) { docID in
      var newContact = Category(
        id: newIndex,
        isCustom: true,
        superIndex: relationType.superIndex,
        isSubEnable: false,
        title: name,
        imageLink: iconString,
        backgroundColor: bgColor.StringFromUIColor())
      self.userViewModel.addCategoryAt(type: .relation, hierarchy: .sub, category: &newContact) { error in
        if let error = error { print("\(error.localizedDescription)")}
      }
    }
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
