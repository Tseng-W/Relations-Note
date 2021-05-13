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

  var relations: Box<[Relation]?> = Box(nil)

  var mockRelation = Relation(id: nil,
                              type: RelationCategory(isPublic: true,
                                                     category: Category(title: "cTitle",
                                                                        imageData: "iData",
                                                                        isCustom: true,
                                                                        subData: [SubCategory(title: "sT",
                                                                                              imageData: "siD",
                                                                                              isCustom: true,
                                                                                              subData: nil,
                                                                                              description: "desc")
                                                                        ],
                                                                        description: "cDesc")
                              ),
                              owner: -1,
                              feature: [],
                              createdTime: Timestamp(date: Date()),
                              lastContactTime: Timestamp(date: Date())
           )

  func fetchRelations(id userID: Int) {
    FirebaseManager.shared.fetchRelationsMock(userID: userID)
  }

  func addRelation(id userID: Int, relation: Relation) {
    FirebaseManager.shared.addRelation(userID: userID, data: relation)
  }

  func onRelationAdded(relation: Relation) {
    relations.value?.append(relation)
  }

  func onRelationModified(relation: Relation) {
    relations.value?[(relations.value?.firstIndex(where: { $0.id == relation.id }))!] = relation
  }

  func onRelationDeleted(relation: Relation) {
    relations.value?.remove(at: (relations.value?.firstIndex(where: { $0.id == relation.id }))!)
  }

  func getCategories() -> [Category] {
    let categories: [Category] = []
    return categories
  }
}
