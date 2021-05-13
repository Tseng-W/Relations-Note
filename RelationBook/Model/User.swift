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
  var id: Int
  var name: String
  var displayName: String
  var features: [Category]
  var customFeatures: [Category]
}
