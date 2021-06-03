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
    if let image = UIImage(systemName: imageLink) ?? UIImage(named: imageLink) {
      completion(image)
    }
  }

  func getColor() -> UIColor {
    return UIColor.UIColorFromString(string: backgroundColor)
  }
}

class CategoryViewModel: Codable {

  enum CategoryType: String, Codable {
    case relation = "relationSet"
    case event = "eventSet"
    case feature = "featureSet"
  }

  var type: CategoryType

  var filter: [String]

  var main: [Category]

  var sub: [Category]

  init(type: CategoryType) {

    self.type = type

    switch type {
    case .relation:
      filter = ["同學", "家人", "同事", "點頭之交", "其他"]
      main = [
        Category(id: 0, isCustom: false, superIndex: 0, isSubEnable: true, title: "大學同學", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 1, isCustom: false, superIndex: 0, isSubEnable: true, title: "高中同學", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 0, isSubEnable: true, title: "國中同學", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 3, isCustom: false, superIndex: 0, isSubEnable: true, title: "小學同學", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 4, isCustom: false, superIndex: 1, isSubEnable: true, title: "父母", imageLink: "house.circle", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 5, isCustom: false, superIndex: 1, isSubEnable: true, title: "親戚", imageLink: "house.circle", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 6, isCustom: false, superIndex: 1, isSubEnable: true, title: "兒女", imageLink: "house.circle", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 7, isCustom: false, superIndex: 1, isSubEnable: true, title: "配偶", imageLink: "house.circle", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 8, isCustom: false, superIndex: 2, isSubEnable: true, title: "XX公司", imageLink: "building.2.crop.circle", backgroundColor: UIColor.systemPink.StringFromUIColor()),
        Category(id: 9, isCustom: false, superIndex: 2, isSubEnable: true, title: "OO公司", imageLink: "building.2.crop.circle", backgroundColor: UIColor.systemPink.StringFromUIColor()),
        Category(id: 10, isCustom: false, superIndex: 2, isSubEnable: true, title: "YY公司", imageLink: "building.2.crop.circle", backgroundColor: UIColor.systemPink.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 3, isSubEnable: true, title: "鄰居", imageLink: "person.2", backgroundColor: UIColor.systemGray.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 3, isSubEnable: true, title: "陌生人", imageLink: "person.2", backgroundColor: UIColor.systemGray.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 3, isSubEnable: true, title: "朋友的朋友", imageLink: "person.2", backgroundColor: UIColor.systemGray.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 4, isSubEnable: true, title: "路人", imageLink: "person.fill.questionmark", backgroundColor: UIColor.systemGray.StringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 4, isSubEnable: true, title: "其他", imageLink: "person.fill.questionmark", backgroundColor: UIColor.systemGray.StringFromUIColor())
      ]
    case .feature:
      filter = ["學習", "事業", "興趣", "特長", "住所", "其他"]
      main = [
        Category(id: 0, isCustom: false, superIndex: 0, isSubEnable: false, title: "畢業", imageLink: "graduationcap", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 1, isSubEnable: false, title: "任職", imageLink: "building.2", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 2, isSubEnable: false, title: "運動", imageLink: "sportscourt", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 3, isSubEnable: false, title: "語言", imageLink: "abc", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 4, isSubEnable: false, title: "租屋", imageLink: "building", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 5, isSubEnable: false, title: "其他", imageLink: "questionmark", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
      ]
    case .event:
      filter = ["偶遇", "會議", "爭執", "聚會", "其他"]
      main = [
        Category(id: 0, isCustom: false, superIndex: 0, isSubEnable: false, title: "打招呼", imageLink: "figure.wave", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, isSubEnable: false, title: "聊天", imageLink: "mouth", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, isSubEnable: false, title: "無視對方", imageLink: "eyes", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 0, isCustom: false, superIndex: 0, isSubEnable: false, title: "被無視", imageLink: "eyeglasses", backgroundColor: UIColor.systemBlue.StringFromUIColor()),
        Category(id: 1, isCustom: false, superIndex: 1, isSubEnable: false, title: "協商", imageLink: "figure.stand.line.dotted.figure.stand", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 1, isCustom: false, superIndex: 1, isSubEnable: false, title: "傾聽", imageLink: "ear", backgroundColor: UIColor.systemTeal.StringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 2, isSubEnable: false, title: "爭吵", imageLink: "hands.clap", backgroundColor: UIColor.systemGreen.StringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 3, isSubEnable: false, title: "遊戲", imageLink: "gamecontroller", backgroundColor: UIColor.systemGreen.StringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 4, isSubEnable: false, title: "其他", imageLink: "textformat.abc.dottedunderline", backgroundColor: UIColor.systemGreen.StringFromUIColor())
      ]
    }
    sub = []
  }

  func getMainCategories(superIndex: Int) -> [Category] {
    if superIndex == -1 {
      return main
    }

    return main.filter { $0.superIndex == superIndex }
  }

  func getSubCategories(superIndex: Int) -> [Category] {
    if superIndex == -1 {
      return sub
    }

    return sub.filter { $0.superIndex == superIndex }
  }

  func toDict() -> [String: Any] {
    return [ "filter": filter,
             "main": main.compactMap{ category in
              category.toDict()
             },
             "sub": sub.compactMap{ category in
              category.toDict()
             },
             "type": type.rawValue
    ]
  }
}


struct Category: Icon {

  var id: Int

  var isCustom: Bool

  var superIndex: Int

  var isSubEnable: Bool

  var title: String

  var imageLink: String

  var backgroundColor: String

  func toDict() -> [String: Any] {
    return [
      "id": id,
      "isCustom": isCustom,
      "superIndex": superIndex,
      "isSubEnable": isSubEnable,
      "title": title,
      "imageLink": imageLink,
      "backgroundColor": backgroundColor
    ]
  }
}
