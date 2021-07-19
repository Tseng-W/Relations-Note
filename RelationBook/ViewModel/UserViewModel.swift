//
//  UserViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import UIKit

enum CategoryType {
  case event

  case relation

  case feature

  case mood
}

enum CategoryHierarchy {
  case main
  case sub
}

class UserViewModel {
  var user: Box<User?> = Box(nil)

  func fetchUserDate() {
    FirebaseManager.shared.fetchUser { [weak self] user in
      self?.user.value = user
    }
  }

  func getCategory(type: CategoryType, event: Event) -> Category? {
    guard let user = user.value,
          type != .mood else { return nil }
    switch type {
    case .event:
      return nil
    case .feature:
      return nil
    case .relation:
      return user.getCategoriesWithSuperIndex(subType: .relation).first { event.relations.contains($0.id) }
    default:
      return nil
    }
  }
}

extension UserViewModel {
  static var moodData: [(image: UIImage, colorString: String)] = [
    (iconEmoji[0], UIColor.systemRed.stringFromUIColor()),
    (iconEmoji[1], UIColor.systemBlue.stringFromUIColor()),
    (iconEmoji[2], UIColor.systemPurple.stringFromUIColor()),
    (iconEmoji[3], UIColor.systemTeal.stringFromUIColor()),
    (iconEmoji[4], UIColor.systemYellow.stringFromUIColor()),
    (iconEmoji[5], UIColor.systemOrange.stringFromUIColor()),
    (iconEmoji[6], UIColor.systemGreen.stringFromUIColor()),
    (iconEmoji[7], UIColor.systemIndigo.stringFromUIColor()),
    (iconEmoji[8], UIColor.systemPink.stringFromUIColor())
  ]
}
