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

  static let shared = UserViewModel()

  var user: Box<User?> = Box(nil)

  var moodsData = Box([Category]())

  func fetchUserDate() {
    let appleID = "mock"
    FirebaseManager.shared.fetchUser(appleID: appleID) { result in
      switch result {
      case .success(let data):
        if let data = data {
          self.user.value = data
          print(">>>>> Fetch ended. <<<<<")
        } else {
          self.initialUser(appleID: appleID)
        }
      case .failure(let error):
        print("\(error.localizedDescription)")
      }
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

  private func initialUser(appleID: String) {
    let newUser = User(docId: "",
                       appleID: appleID,
                       name: "mockName",
                       displayName: "mockDisplayName")
    FirebaseManager.shared.addUser(user: newUser) { user in
      self.user.value = user

    }
  }

  func addCategoryAt(type: CategoryType, hierarchy: CategoryHierarchy, category: inout Category, completion: @escaping (Error?) -> Void) {

    guard let user = user.value else { return }

    let categories = type == .event ? user.eventSet :
      type == .feature ? user.featureSet : user.relationSet

    switch hierarchy {
    case .main:
      category.id = user.getFilter(type: type).count
      category.isSubEnable = type == .event ? false : true
      categories.main.append(category)
    case .sub:
      category.id = user.getCategoriesWithSuperIndex(type: type, filterIndex: category.superIndex).count
      category.isSubEnable = false
      categories.sub.append(category)
    }

    FirebaseManager.shared.updateDocument(docID: user.docId!, dict: [categories.type.rawValue : categories.toDict()]) { error in
      if let error = error { completion(error); return}
    }
  }
}
