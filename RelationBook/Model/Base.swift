//
//  BaseObject.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import UIKit

enum Collections: String {
  case user = "Users"
  case event = "Events"
  case relation = "Relations"
}

protocol Icon: Codable {
  associatedtype subIconType
  var isCustom: Bool { get }
  var title: String { get }
  var imageData: String { get }
  var description: String? { get }
  var subData: [subIconType]? { get }
}

extension Icon {
  func getImage() -> UIImage? {
    return imageData.toImage()
  }
}

struct Category: Icon {
  typealias subIconType = SubCategory

  var title: String

  var imageData: String

  var isCustom: Bool

  var subData: [SubCategory]?

  var description: String?
}

struct SubCategory: Icon {

  typealias subIconType = Self

  var title: String

  var imageData: String

  var isCustom: Bool

  var subData: [SubCategory]? = nil

  var description: String?
}

struct Feature: Codable {
  var titlee: String
  var subFeatures: [SubFeature]
}

struct SubFeature: Codable {
  var iconImage: String
  var title: String
}
