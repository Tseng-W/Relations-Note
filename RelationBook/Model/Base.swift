//
//  BaseObject.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import UIKit
import Kingfisher

enum Collections: String {

  case user = "Users"

  case event = "Events"

  case relation = "Relations"
}

protocol Icon: Codable {

  var id: Int { get }

  var isCustom: Bool { get }

  var title: String { get }

  var imageLink: String { get }

  var backgroundColor: String { get }
}

extension Icon {

  func getImage(completion: @escaping (UIImage?) -> Void) {
    if isCustom {
      UIImage.loadImage(imageLink, completion: completion)
    }
    completion(UIImage(systemName: imageLink))
  }

  func getColor() -> UIColor {
    return UIColor.UIColorFromString(string: backgroundColor)
  }
}

struct Category: Icon {

  var id: Int

  var isCustom: Bool

  var superIndex: Int

  var title: String

  var imageLink: String

  var backgroundColor: String
}
