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
}

enum CategoryHierarchy {
  case main
  case sub
}

class UserViewModel {
  
  var user: Box<User?> = Box(nil)

  var moodsData = Box([Category]())

  func fetchUserDate() {

    FirebaseManager.shared.fetchUser() { [weak self] user in
      self?.user.value = user
    }
  }

  var mockMoodData: [(title: String, imageName: String, colorString: String)] = [
    ("憤怒", ImageAsset.emojiAngry.rawValue, UIColor.systemRed.StringFromUIColor()),
    ("傷心", ImageAsset.emojiSad.rawValue, UIColor.systemBlue.StringFromUIColor()),
    ("無言", ImageAsset.emojiWaiting.rawValue, UIColor.systemPurple.StringFromUIColor()),
    ("困惑", ImageAsset.emojiConfused.rawValue, UIColor.systemTeal.StringFromUIColor()),
    ("無聊", ImageAsset.emojiSleeping.rawValue, UIColor.systemYellow.StringFromUIColor()),
    ("快樂", ImageAsset.emojiHappy.rawValue, UIColor.systemOrange.StringFromUIColor()),
    ("興奮", ImageAsset.emojiGrin.rawValue, UIColor.systemGreen.StringFromUIColor()),
    ("期待", ImageAsset.emojiWinking.rawValue, UIColor.systemIndigo.StringFromUIColor()),
    ("著迷", ImageAsset.emojiLove.rawValue, UIColor.systemPink.StringFromUIColor())
  ]

  func fetchMood() {
    mockMoodData.forEach { (title ,image, color) in
      moodsData.value.append(
        Category(id: moodsData.value.count, isCustom: false, superIndex: -1, isSubEnable: false, title: title, imageLink: image, backgroundColor: color)
      )
    }
  }
}
