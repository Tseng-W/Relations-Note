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

class CategoryViewModel: Codable {

  enum CategoryType {
    case relation
    case event
    case feature
  }

  var filter: [String]

  var main: [Category]

  var sub: [Category]

  init(type: CategoryType) {
    switch type {
    case .relation:
      filter = ["同學", "家人", "同事", "點頭之交", "其他"]
      main = [
        Category(id: 0, isCustom: false, superIndex: 0, title: "大學同學", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 1, isCustom: false, superIndex: 0, title: "高中同學", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 0, title: "國中同學", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 3, isCustom: false, superIndex: 0, title: "小學同學", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 4, isCustom: false, superIndex: 1, title: "父母", imageLink: "house.circle", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 5, isCustom: false, superIndex: 1, title: "親戚", imageLink: "house.circle", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 6, isCustom: false, superIndex: 1, title: "兒女", imageLink: "house.circle", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 7, isCustom: false, superIndex: 1, title: "配偶", imageLink: "house.circle", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 8, isCustom: false, superIndex: 2, title: "XX公司", imageLink: "building.2.crop.circle", backgroundColor: UIColor.systemPink.StringFromUIColor()),
        Category(id: 9, isCustom: false, superIndex: 2, title: "OO公司", imageLink: "building.2.crop.circle", backgroundColor: UIColor.systemPink.StringFromUIColor()),
        Category(id: 10, isCustom: false, superIndex: 2, title: "YY公司", imageLink: "building.2.crop.circle", backgroundColor: UIColor.systemPink.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 3, title: "鄰居", imageLink: "person.2", backgroundColor: UIColor.systemGray.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 3, title: "陌生人", imageLink: "person.2", backgroundColor: UIColor.systemGray.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 3, title: "朋友的朋友", imageLink: "person.2", backgroundColor: UIColor.systemGray.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 4, title: "路人", imageLink: "person.fill.questionmark", backgroundColor: UIColor.systemGray.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 4, title: "其他", imageLink: "person.fill.questionmark", backgroundColor: UIColor.systemGray.StringFromUIColor())
      ]
    case .feature:
      filter = ["學習", "事業", "興趣", "特長", "住所", "其他"]
      main = [
        Category(id: 0, isCustom: false, superIndex: 0, title: "畢業", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, title: "任職", imageLink: "building.2", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, title: "運動", imageLink: "sportscourt", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, title: "語言", imageLink: "abc", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, title: "租屋", imageLink: "building", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, title: "其他", imageLink: "questionmark", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
      ]
    case .event:
      filter = ["偶遇", "會議", "爭執", "聚會", "其他"]
      main = [
        Category(id: 0, isCustom: false, superIndex: 0, title: "打招呼", imageLink: "figure.wave", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, title: "聊天", imageLink: "mouth", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, title: "無視對方", imageLink: "eyes", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, title: "被無視", imageLink: "eyeglasses", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 1, isCustom: false, superIndex: 1, title: "協商", imageLink: "figure.stand.line.dotted.figure.stand", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 1, isCustom: false, superIndex: 1, title: "傾聽", imageLink: "ear", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 2, title: "爭吵", imageLink: "hands.clap", backgroundColor: UIColor.systemGreen.StringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 3, title: "遊戲", imageLink: "gamecontroller", backgroundColor: UIColor.systemGreen.StringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 4, title: "其他", imageLink: "textformat.abc.dottedunderline", backgroundColor: UIColor.systemGreen.StringFromUIColor())
      ]
    }
    sub = []
  }

  func getMainCategories(superIndex: Int) -> [Category] {
    guard superIndex < filter.count else { return [] }
    return main.filter { $0.superIndex == superIndex }
  }

  func getSubCategories(superIndex: Int) -> [Category] {
    guard superIndex < filter.count else { return [] }
    return sub.filter { $0.superIndex == superIndex }
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
