//
//  UserObject.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable {
  @DocumentID var uid: String?
  var email: String
  var relationSet = CategoryViewModel.init(type: .relation)
  var featureSet = CategoryViewModel.init(type: .feature)
  var eventSet = CategoryViewModel.init(type: .event)

  func getFilter(type: CategoryType) -> [String] {
    switch type {
    case .event:
      return eventSet.filter
    case .feature:
      return featureSet.filter
    case .relation:
      return relationSet.filter
    default:
      return []
    }
  }

  func getCategoriesWithSuperIndex(mainType type: CategoryType, filterIndex index: Int = -1) -> [Category] {
    switch type {
    case .event:
      return eventSet.getMainCategories(superIndex: index)
    case .feature:
      return featureSet.getMainCategories(superIndex: index)
    case .relation:
      return relationSet.getMainCategories(superIndex: index)
    default:
      return []
    }
  }

  func getCategoriesWithSuperIndex(subType type: CategoryType, mainIndex index: Int = -1) -> [Category] {
    switch type {
    case .event:
      return eventSet.getSubCategories(superIndex: index)
    case .feature:
      return featureSet.getSubCategories(superIndex: index)
    case .relation:
      return relationSet.getSubCategories(superIndex: index)
    default:
      return []
    }
  }
}
