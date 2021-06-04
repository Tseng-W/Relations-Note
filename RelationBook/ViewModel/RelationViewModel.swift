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

    FirebaseManager.shared.fetchRelations(uid: uid) { [weak self] relations in
      self?.relations.value = relations
    }
  }

  func fetchRelation(categoryID: Int, completion: (Bool) -> Void) {

    let relation = FirebaseManager.shared.relations.filter { relation in
      relation.categoryIndex == categoryID
    }

    if relation.count > 1 { print("More than one relation with same category ID!.")}

    if relation.count == 0 {
      completion(false)
    } else if relation.count == 1 {
      relations.value = relation
      completion(true)
    }
  }

  func getRelationAt(index: Int) -> Relation? {
    if index < relations.value.count {
      return relations.value[index]
    }
    return nil
  }

  func addRelation(name: String, iconString: String, bgColor: UIColor, superIndex: Int, feature: Feature) {

    guard let user = FirebaseManager.shared.userShared else { return }

    let newIndex = user.getCategoriesWithSuperIndex(subType: .relation).count

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
        isCustom: iconString.verifyUrl(),
        superIndex: superIndex,
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
