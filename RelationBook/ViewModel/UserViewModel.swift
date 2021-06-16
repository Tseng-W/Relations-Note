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
}

extension UserViewModel {
  static var moodData: [(imageName: String, colorString: String)] = [
    (EmojiIcon.emojiAngry.rawValue, UIColor.systemRed.stringFromUIColor()),
    (EmojiIcon.emojiSad.rawValue, UIColor.systemBlue.stringFromUIColor()),
    (EmojiIcon.emojiWaiting.rawValue, UIColor.systemPurple.stringFromUIColor()),
    (EmojiIcon.emojiConfused.rawValue, UIColor.systemTeal.stringFromUIColor()),
    (EmojiIcon.emojiSleeping.rawValue, UIColor.systemYellow.stringFromUIColor()),
    (EmojiIcon.emojiHappy.rawValue, UIColor.systemOrange.stringFromUIColor()),
    (EmojiIcon.emojiGrin.rawValue, UIColor.systemGreen.stringFromUIColor()),
    (EmojiIcon.emojiWinking.rawValue, UIColor.systemIndigo.stringFromUIColor()),
    (EmojiIcon.emojiLove.rawValue, UIColor.systemPink.stringFromUIColor())
  ]
}
