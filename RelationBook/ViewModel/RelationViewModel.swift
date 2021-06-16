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

  func fetchRelations(index: Int, completion: @escaping (Relation?) -> Void) {
    guard let uid = UserDefaults.standard.getString(key: .uid) else { return }

    FirebaseManager.shared.fetchRelations(uid: uid, index: index) { [weak self] relations in
      self?.relations.value = relations
      if relations.count == 1 {
        completion(relations[0])
      }
    }
  }

  func getRelationAt(index: Int) -> Relation? {
    if index < relations.value.count {
      return relations.value[index]
    }
    return nil
  }

  func addRelation(name: String, iconString: String, bgColor: UIColor, superIndex: Int, features: [Feature] = [], completion: @escaping () -> Void = {}) {
    guard let user = FirebaseManager.shared.userShared,
          let userId = user.uid else { return }

    let newIndex = user.getCategoriesWithSuperIndex(subType: .relation).count

    let relation = Relation(
      id: nil,
      name: name,
      isPublic: false,
      categoryIndex: newIndex,
      owner: userId,
      feature: features,
      createdTime: Timestamp(date: Date()),
      lastContactTime: Timestamp(date: Date()))

    FirebaseManager.shared.addRelation(userID: relation.owner, data: relation) { _ in
      var newContact = Category(
        id: newIndex,
        isCustom: iconString.verifyUrl(),
        superIndex: superIndex,
        isSubEnable: false,
        title: name,
        imageLink: iconString,
        backgroundColor: bgColor.stringFromUIColor())
      FirebaseManager.shared.addUserCategory(type: .relation, hierarchy: .sub, category: &newContact)
    }
  }

  static func updateRelation(categoryIndex: Int, name: String? = nil, bgColor: UIColor? = nil, feature: [Feature]? = nil) {
    if let feature = feature {
      let dict = feature.map { $0.toDict() }

      FirebaseManager.shared.updateRelation(categoryIndex: categoryIndex, dict: ["feature": dict])
    }
  }

  func onRelationAdded(relation: Relation) {
    relations.value.append(relation)
  }

  func onRelationModified(relation: Relation) {
    if let index = relations.value.firstIndex(where: { $0.id == relation.id }) {
      relations.value[index] = relation
    }
  }

  func onRelationDeleted(relation: Relation) {
    if let index = relations.value.firstIndex(where: { $0.id == relation.id }) {
      relations.value.remove(at: index)
    }
  }
}
