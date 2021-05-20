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

class UserViewModel {

  var user: Box<User?> = Box(nil)

  var moodsData = Box([Category]())

  var mockRelationFilterTitle = ["同學", "家人", "同事", "點頭之交"]

  var mockEventFilterTitle = ["偶遇", "日常會面", "會議"]

  var mockFeatureFilterTitle = ["無"]

  var mockFeatureCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "求學", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 1, isCustom: false, superIndex: 0, title: "事業", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor())
  ]

  var mockFeatureSubCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "畢業", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 1, isCustom: false, superIndex: 0, title: "任職", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor())
  ]

  var mockRelationCategory: [Category] = [
  Category(id: 0, isCustom: false, superIndex: 0, title: "大學同學", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
  Category(id: 1, isCustom: false, superIndex: 0, title: "高中同學", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
  Category(id: 2, isCustom: false, superIndex: 0, title: "國中同學", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
  Category(id: 3, isCustom: false, superIndex: 0, title: "小學同學", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
  Category(id: 4, isCustom: false, superIndex: 1, title: "父母", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
  Category(id: 5, isCustom: false, superIndex: 1, title: "親戚", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
  Category(id: 6, isCustom: false, superIndex: 1, title: "兒女", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
  Category(id: 7, isCustom: false, superIndex: 1, title: "配偶", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
  Category(id: 8, isCustom: false, superIndex: 2, title: "XX公司", imageLink: "", backgroundColor: UIColor.systemPink.StringFromUIColor()),
  Category(id: 9, isCustom: false, superIndex: 2, title: "OO公司", imageLink: "", backgroundColor: UIColor.systemPink.StringFromUIColor()),
  Category(id: 10, isCustom: false, superIndex: 2, title: "YY公司", imageLink: "", backgroundColor: UIColor.systemPink.StringFromUIColor()),
  Category(id: 11, isCustom: false, superIndex: 3, title: "路人", imageLink: "", backgroundColor: UIColor.systemGray.StringFromUIColor())
]

  var mockRelationSubCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "陳某某", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 1, isCustom: false, superIndex: 0, title: "洪某某", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 2, isCustom: false, superIndex: 1, title: "曾某某", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 3, isCustom: false, superIndex: 1, title: "林某某", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 4, isCustom: false, superIndex: 2, title: "曾某某", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 5, isCustom: false, superIndex: 2, title: "林某某", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 6, isCustom: false, superIndex: 3, title: "曾某某", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 7, isCustom: false, superIndex: 4, title: "林某某", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
    Category(id: 8, isCustom: false, superIndex: 5, title: "曾某某", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
    Category(id: 9, isCustom: false, superIndex: 6, title: "林某某", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
    Category(id: 10, isCustom: false, superIndex: 7, title: "陳某某", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
    Category(id: 11, isCustom: false, superIndex: 8, title: "洪某某", imageLink: "", backgroundColor: UIColor.systemPink.StringFromUIColor()),
    Category(id: 12, isCustom: false, superIndex: 9, title: "曾某某", imageLink: "", backgroundColor: UIColor.systemPink.StringFromUIColor()),
    Category(id: 13, isCustom: false, superIndex: 10, title: "林某某", imageLink: "", backgroundColor: UIColor.systemPink.StringFromUIColor()),
    Category(id: 14, isCustom: false, superIndex: 11, title: "曾某某", imageLink: "", backgroundColor: UIColor.systemGray.StringFromUIColor())
  ]

  private var mockEventCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "招呼", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 1, isCustom: false, superIndex: 1, title: "閒聊", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
    Category(id: 2, isCustom: false, superIndex: 2, title: "會議", imageLink: "", backgroundColor: UIColor.systemGreen.StringFromUIColor())
  ]

  private var mockEventSubCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "新認識", imageLink: "", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
    Category(id: 1, isCustom: false, superIndex: 1, title: "聊天", imageLink: "", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
    Category(id: 2, isCustom: false, superIndex: 2, title: "會議", imageLink: "", backgroundColor: UIColor.systemGreen.StringFromUIColor())
  ]

  func fetchUserDate() {
    let appleID = "mock"
    FirebaseManager.shared.fetchUser(appleID: appleID) { result in
      switch result {
      case .success(let data):
        if let data = data {
          self.user.value = data
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

  func getCategoriesWithSuperIndex(type: CategoryType, index: Int) -> [Category] {
    switch type {
    case .event:
      return user.value?.eventSet.getMainCategories(superIndex: index) ?? []
//      return mockEventCategory.filter { $0.superIndex == index }
    case .feature:
      return user.value?.featureSet.getMainCategories(superIndex: index) ?? []
//      return mockFeatureCategory.filter { $0.superIndex == index }
    case .relation:
      return user.value?.relationSet.getMainCategories(superIndex: index) ?? []
//      return mockRelationCategory.filter { $0.superIndex == index }
    }
  }

  func getSubCategoriesWithSuperIndex(type: CategoryType, index: Int) -> [Category]? {
    switch type {
    case .event:
      return user.value?.eventSet.getSubCategories(superIndex: index) ?? []
//      return mockEventSubCategory.filter { $0.superIndex == id }
    case .feature:
      return user.value?.featureSet.getSubCategories(superIndex: index) ?? []
//      return mockFeatureSubCategory.filter { $0.superIndex == id }
    case .relation:
      return user.value?.relationSet.getSubCategories(superIndex: index) ?? []
//      return mockRelationSubCategory.filter { $0.superIndex == id }
    }
  }

  func getFilter(type: CategoryType) -> [String] {
    switch type {
    case .event:
      return user.value?.eventSet.filter ?? []
//      return mockEventFilterTitle
    case .feature:
      return user.value?.featureSet.filter ?? []
//      return mockFeatureFilterTitle
    case .relation:
      return user.value?.relationSet.filter ?? []
//      return mockRelationFilterTitle
    }
  }

  func fetchMood() {
    mockMoodData.forEach { (title ,image, color) in
      moodsData.value.append(
        Category(id: moodsData.value.count, isCustom: false, superIndex: -1, title: title, imageLink: image, backgroundColor: color)
      )
    }
  }

  private func initialUser(appleID: String) {
    var newUser = User(docId: "",
                       appleID: appleID,
                       name: "mockName",
                       displayName: "mockDisplayName")
    FirebaseManager.shared.addUser(user: &newUser)
  }
}
