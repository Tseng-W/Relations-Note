//
//  FillterViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/10.
//

import UIKit
import Firebase

class RelationViewModel {

  var relations = Box([Relation]())

  func fetchRelations() {
    guard let uid = UserDefaults.standard.getString(key: .uid) else { return }

    FirebaseManager.shared.fetchRelations(uid: uid)
  }

  func addRelation(name: String, iconString: String, bgColor: UIColor, relationType: Category, feature: Feature) {

    guard let user = FirebaseManager.shared.userShared.value else { return }

    let newIndex = user.getCategoriesWithSuperIndex(type: .relation, mainIndex: relationType.id).count

    let relation = Relation(
      id: nil,
      name: name,
      isPublic: false,
      categoryIndex: newIndex,
      owner: user.uid!,
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
      FirebaseManager.shared.addUserCategory(type: .relation, hierarchy: .sub, category: &newContact)
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
