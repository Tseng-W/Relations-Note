//
//  UserObject.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation
import FirebaseFirestoreSwift

struct User: Codable{
  @DocumentID var docId: String?
  var appleID: String
  var name: String
  var displayName: String
  var relationSet: CategoryViewModel = CategoryViewModel.init(type: .relation)
  var featureSet: CategoryViewModel = CategoryViewModel.init(type: .feature)
  var eventSet: CategoryViewModel = CategoryViewModel.init(type: .event)
}
