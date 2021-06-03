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

    FirebaseManager.shared.fetchUser() { [weak self] user in
      self?.user.value = user
    }
  }
}

extension UserViewModel {
  static var moodData: [(title: String, imageName: String, colorString: String)] = [
    ("憤怒", EmojiIcon.emojiAngry.rawValue, UIColor.systemRed.StringFromUIColor()),
    ("傷心", EmojiIcon.emojiSad.rawValue, UIColor.systemBlue.StringFromUIColor()),
    ("無言", EmojiIcon.emojiWaiting.rawValue, UIColor.systemPurple.StringFromUIColor()),
    ("困惑", EmojiIcon.emojiConfused.rawValue, UIColor.systemTeal.StringFromUIColor()),
    ("無聊", EmojiIcon.emojiSleeping.rawValue, UIColor.systemYellow.StringFromUIColor()),
    ("快樂", EmojiIcon.emojiHappy.rawValue, UIColor.systemOrange.StringFromUIColor()),
    ("興奮", EmojiIcon.emojiGrin.rawValue, UIColor.systemGreen.StringFromUIColor()),
    ("期待", EmojiIcon.emojiWinking.rawValue, UIColor.systemIndigo.StringFromUIColor()),
    ("著迷", EmojiIcon.emojiLove.rawValue, UIColor.systemPink.StringFromUIColor())
  ]
}
