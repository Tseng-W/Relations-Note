//
//  UserViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import Foundation

enum CategoryType {

  case event

  case relation

  case feature
}

class UserViewModel {

  static let shared = UserViewModel()

  private var mockRelationFilterTitle = ["同學", "家人", "同事", "點頭之交"]

  private var mockEventFilterTitle = ["偶遇", "日常會面", "會議"]

  private var mockFeatureFilterTitle = ["無"]

  private var mockFeatureCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "求學", imageLink: ""),
    Category(id: 1, isCustom: false, superIndex: 0, title: "事業", imageLink: "")
  ]

  private var mockFeatureSubCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "畢業", imageLink: ""),
    Category(id: 1, isCustom: false, superIndex: 0, title: "任職", imageLink: "")
  ]

  private var mockRelationCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "大學同學", imageLink: ""),
    Category(id: 1, isCustom: false, superIndex: 0, title: "高中同學", imageLink: ""),
    Category(id: 2, isCustom: false, superIndex: 0, title: "國中同學", imageLink: ""),
    Category(id: 3, isCustom: false, superIndex: 0, title: "小學同學", imageLink: ""),
    Category(id: 4, isCustom: false, superIndex: 1, title: "父母", imageLink: ""),
    Category(id: 5, isCustom: false, superIndex: 1, title: "親戚", imageLink: ""),
    Category(id: 6, isCustom: false, superIndex: 1, title: "兒女", imageLink: ""),
    Category(id: 7, isCustom: false, superIndex: 1, title: "配偶", imageLink: ""),
    Category(id: 8, isCustom: false, superIndex: 2, title: "XX公司", imageLink: ""),
    Category(id: 9, isCustom: false, superIndex: 2, title: "OO公司", imageLink: ""),
    Category(id: 10, isCustom: false, superIndex: 2, title: "YY公司", imageLink: ""),
    Category(id: 11, isCustom: false, superIndex: 2, title: "配偶", imageLink: ""),
    Category(id: 12, isCustom: false, superIndex: 3, title: "路人", imageLink: "")
  ]

  private var mockRelationSubCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "陳某某", imageLink: ""),
    Category(id: 1, isCustom: false, superIndex: 0, title: "洪某某", imageLink: ""),
    Category(id: 2, isCustom: false, superIndex: 1, title: "曾某某", imageLink: ""),
    Category(id: 3, isCustom: false, superIndex: 1, title: "林某某", imageLink: ""),
    Category(id: 4, isCustom: false, superIndex: 2, title: "曾某某", imageLink: ""),
    Category(id: 5, isCustom: false, superIndex: 2, title: "林某某", imageLink: ""),
    Category(id: 6, isCustom: false, superIndex: 3, title: "曾某某", imageLink: ""),
    Category(id: 7, isCustom: false, superIndex: 4, title: "林某某", imageLink: ""),
    Category(id: 8, isCustom: false, superIndex: 5, title: "曾某某", imageLink: ""),
    Category(id: 9, isCustom: false, superIndex: 6, title: "林某某", imageLink: ""),
    Category(id: 10, isCustom: false, superIndex: 7, title: "陳某某", imageLink: ""),
    Category(id: 11, isCustom: false, superIndex: 8, title: "洪某某", imageLink: ""),
    Category(id: 12, isCustom: false, superIndex: 9, title: "曾某某", imageLink: ""),
    Category(id: 13, isCustom: false, superIndex: 10, title: "林某某", imageLink: ""),
    Category(id: 14, isCustom: false, superIndex: 11, title: "曾某某", imageLink: ""),
    Category(id: 15, isCustom: false, superIndex: 12, title: "林某某", imageLink: "")
  ]

  private var mockEventCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "招呼", imageLink: ""),
    Category(id: 1, isCustom: false, superIndex: 1, title: "閒聊", imageLink: ""),
    Category(id: 2, isCustom: false, superIndex: 2, title: "會議", imageLink: "")
  ]

  private var mockEventSubCategory: [Category] = [
    Category(id: 0, isCustom: false, superIndex: 0, title: "新認識", imageLink: ""),
    Category(id: 1, isCustom: false, superIndex: 1, title: "", imageLink: ""),
    Category(id: 2, isCustom: false, superIndex: 2, title: "會議", imageLink: "")
  ]

  func getCategoriesWithSuperIndex(type: CategoryType, index: Int) -> [Category] {
    switch type {
    case .event:
      return mockEventCategory.filter { $0.superIndex == index }
    case .feature:
      return mockFeatureCategory.filter { $0.superIndex == index }
    case .relation:
      return mockRelationCategory.filter { $0.superIndex == index }
    }
  }

  func getSubCategoriesWithSuperIndex(type: CategoryType, id: Int) -> [Category]? {
    switch type {
    case .event:
      return mockEventSubCategory.filter { $0.superIndex == id }
    case .feature:
      return mockFeatureSubCategory.filter { $0.superIndex == id }
    case .relation:
      return mockRelationSubCategory.filter { $0.superIndex == id }
    }
  }

  func getFilter(type: CategoryType) -> [String] {
    switch type {
    case .event:
      return mockEventFilterTitle
    case .feature:
      return mockFeatureFilterTitle
    case .relation:
      return mockRelationFilterTitle
    }
  }

  func getCategoryAtIndex(type: CategoryType, index: Int) -> Category? {
    switch type {
    case .event:
      guard index < mockEventCategory.count else { return nil}
      return mockEventCategory[index]
    case .feature:
      guard index < mockFeatureCategory.count else { return nil}
      return mockFeatureCategory[index]
    case .relation:
      guard index < mockRelationCategory.count else { return nil}
      return mockRelationCategory[index]
    }
  }

  func getSubCategoryAtIndex(type: CategoryType, index: Int) -> Category? {
    switch type {
    case .event:
      guard index < mockEventSubCategory.count else { return nil}
      return mockEventSubCategory[index]
    case .feature:
      guard index < mockFeatureSubCategory.count else { return nil}
      return mockFeatureSubCategory[index]
    case .relation:
      guard index < mockRelationSubCategory.count else { return nil}
      return mockRelationSubCategory[index]
    }
  }
}
