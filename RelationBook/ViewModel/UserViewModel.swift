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
    ("憤怒", "face.smiling.fill", UIColor.systemRed.StringFromUIColor()),
    ("傷心", "face.smiling.fill", UIColor.systemBlue.StringFromUIColor()),
    ("無聊", "face.smiling.fill", UIColor.systemYellow.StringFromUIColor()),
    ("輕鬆", "face.smiling.fill", UIColor.systemTeal.StringFromUIColor()),
    ("快樂", "face.smiling.fill", UIColor.systemGreen.StringFromUIColor())
  ]

  func fetchMood() {
    mockMoodData.forEach { (title ,image, color) in
      moodsData.value.append(
        Category(id: moodsData.value.count, isCustom: false, superIndex: -1, isSubEnable: false, title: title, imageLink: image, backgroundColor: color)
      )
    }
  }
}
