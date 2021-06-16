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
    ("憤怒", EmojiIcon.emojiAngry.rawValue, UIColor.systemRed.stringFromUIColor()),
    ("傷心", EmojiIcon.emojiSad.rawValue, UIColor.systemBlue.stringFromUIColor()),
    ("無言", EmojiIcon.emojiWaiting.rawValue, UIColor.systemPurple.stringFromUIColor()),
    ("困惑", EmojiIcon.emojiConfused.rawValue, UIColor.systemTeal.stringFromUIColor()),
    ("無聊", EmojiIcon.emojiSleeping.rawValue, UIColor.systemYellow.stringFromUIColor()),
    ("快樂", EmojiIcon.emojiHappy.rawValue, UIColor.systemOrange.stringFromUIColor()),
    ("興奮", EmojiIcon.emojiGrin.rawValue, UIColor.systemGreen.stringFromUIColor()),
    ("期待", EmojiIcon.emojiWinking.rawValue, UIColor.systemIndigo.stringFromUIColor()),
    ("著迷", EmojiIcon.emojiLove.rawValue, UIColor.systemPink.stringFromUIColor())
  ]
}
