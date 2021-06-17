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

    if imageLink.verifyUrl() {
      UIImage.loadImage(imageLink, completion: completion)
    } else if let image = UIImage(systemName: imageLink) ?? UIImage(named: imageLink) {
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
      filter = ["家庭成員", "閨蜜死黨", "同儕好友", "導師前輩", "同事下屬", "鄰里住居", "親暱關係", "結拜關係", "其他"]
      main = [
        Category(id: 0, isCustom: false, superIndex: 0, isSubEnable: true, title: "祖父母", imageLink: "icon_32px_c_l_17", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 1, isCustom: false, superIndex: 0, isSubEnable: true, title: "父母", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 0, isSubEnable: true, title: "叔叔姑姑", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 3, isCustom: false, superIndex: 0, isSubEnable: true, title: "兄弟姐妹", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 4, isCustom: false, superIndex: 0, isSubEnable: true, title: "姪子姪女", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 5, isCustom: false, superIndex: 0, isSubEnable: true, title: "夫妻", imageLink: "icon_32px_c_l_18", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 6, isCustom: false, superIndex: 0, isSubEnable: true, title: "子女", imageLink: "icon_32px_c_l_15", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 7, isCustom: false, superIndex: 0, isSubEnable: true, title: "孫子孫女", imageLink: "icon_32px_c_l_15", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 8, isCustom: false, superIndex: 0, isSubEnable: true, title: "遠親", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 9, isCustom: false, superIndex: 1, isSubEnable: true, title: "閨蜜", imageLink: "icon_32px_c_l_19", backgroundColor: UIColor.categoryColor9.stringFromUIColor()),
        Category(id: 10, isCustom: false, superIndex: 1, isSubEnable: true, title: "死黨", imageLink: "icon_32px_c_l_19", backgroundColor: UIColor.categoryColor9.stringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 2, isSubEnable: true, title: "學長姐", imageLink: "icon_32px_c_l_25", backgroundColor: UIColor.categoryColor2.stringFromUIColor()),
        Category(id: 12, isCustom: false, superIndex: 2, isSubEnable: true, title: "學弟妹", imageLink: "icon_32px_c_l_25", backgroundColor: UIColor.categoryColor2.stringFromUIColor()),
        Category(id: 13, isCustom: false, superIndex: 2, isSubEnable: true, title: "社團好友", imageLink: "icon_32px_c_l_25", backgroundColor: UIColor.categoryColor2.stringFromUIColor()),
        Category(id: 14, isCustom: false, superIndex: 3, isSubEnable: true, title: "老師", imageLink: "icon_32px_c_l_8", backgroundColor: UIColor.categoryColor3.stringFromUIColor()),
        Category(id: 15, isCustom: false, superIndex: 3, isSubEnable: true, title: "學生", imageLink: "icon_32px_c_l_8", backgroundColor: UIColor.categoryColor3.stringFromUIColor()),
        Category(id: 16, isCustom: false, superIndex: 4, isSubEnable: true, title: "老闆", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 17, isCustom: false, superIndex: 4, isSubEnable: true, title: "主管", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 18, isCustom: false, superIndex: 4, isSubEnable: true, title: "同事", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 19, isCustom: false, superIndex: 4, isSubEnable: true, title: "前老闆", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 20, isCustom: false, superIndex: 4, isSubEnable: true, title: "前主管", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 21, isCustom: false, superIndex: 4, isSubEnable: true, title: "前同事", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 22, isCustom: false, superIndex: 5, isSubEnable: true, title: "鄰居", imageLink: "icon_32px_c_l_33", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 23, isCustom: false, superIndex: 5, isSubEnable: true, title: "房東", imageLink: "icon_32px_c_l_33", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 24, isCustom: false, superIndex: 5, isSubEnable: true, title: "房客", imageLink: "icon_32px_c_l_33", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 25, isCustom: false, superIndex: 5, isSubEnable: true, title: "同居人", imageLink: "icon_32px_c_l_33", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 26, isCustom: false, superIndex: 6, isSubEnable: true, title: "男女朋友", imageLink: "icon_32px_c_l_18", backgroundColor: UIColor.categoryColor6.stringFromUIColor()),
        Category(id: 27, isCustom: false, superIndex: 6, isSubEnable: true, title: "前男女朋友", imageLink: "icon_32px_c_l_18", backgroundColor: UIColor.categoryColor6.stringFromUIColor()),
        Category(id: 28, isCustom: false, superIndex: 6, isSubEnable: true, title: "老友", imageLink: "icon_32px_c_l_23", backgroundColor: UIColor.categoryColor6.stringFromUIColor()),
        Category(id: 29, isCustom: false, superIndex: 7, isSubEnable: true, title: "乾爹乾媽", imageLink: "icon_32px_c_l_24", backgroundColor: UIColor.categoryColor7.stringFromUIColor()),
        Category(id: 30, isCustom: false, superIndex: 7, isSubEnable: true, title: "乾兄弟", imageLink: "icon_32px_c_l_24", backgroundColor: UIColor.categoryColor7.stringFromUIColor()),
        Category(id: 31, isCustom: false, superIndex: 7, isSubEnable: true, title: "乾姐妹", imageLink: "icon_32px_c_l_24", backgroundColor: UIColor.categoryColor7.stringFromUIColor()),
        Category(id: 32, isCustom: false, superIndex: 8, isSubEnable: true, title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor())
      ]


    case .feature:
      filter = ["個人資訊", "情感狀態", "學習歷程", "職涯發展", "興趣特長", "其他"]
      main = [
        Category(id: 0, isCustom: false, superIndex: 0, isSubEnable: false, title: "暱稱", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 1, isCustom: false, superIndex: 0, isSubEnable: false, title: "生理性別", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 0, isSubEnable: false, title: "電話號碼", imageLink: "icon_32px_f_l_46", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 4, isCustom: false, superIndex: 0, isSubEnable: false, title: "生日", imageLink: "icon_32px_f_l_26", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 5, isCustom: false, superIndex: 0, isSubEnable: false, title: "星座", imageLink: "icon_32px_f_l_106", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 6, isCustom: false, superIndex: 0, isSubEnable: false, title: "居住地", imageLink: "icon_32px_c_l_12", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 7, isCustom: false, superIndex: 0, isSubEnable: false, title: "外貌特徵", imageLink: "icon_32px_f_l_65", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 8, isCustom: false, superIndex: 0, isSubEnable: false, title: "個性", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 9, isCustom: false, superIndex: 0, isSubEnable: false, title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor()),
        Category(id: 10, isCustom: false, superIndex: 1, isSubEnable: false, title: "交往", imageLink: "icon_32px_c_l_20", backgroundColor: UIColor.categoryColor6.stringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 1, isSubEnable: false, title: "婚嫁", imageLink: "icon_32px_c_l_20", backgroundColor: UIColor.categoryColor6.stringFromUIColor()),
        Category(id: 12, isCustom: false, superIndex: 2, isSubEnable: false, title: "畢業", imageLink: "icon_32px_c_l_6", backgroundColor: UIColor.categoryColor3.stringFromUIColor()),
        Category(id: 13, isCustom: false, superIndex: 2, isSubEnable: false, title: "休學", imageLink: "icon_32px_c_l_6", backgroundColor: UIColor.categoryColor3.stringFromUIColor()),
        Category(id: 14, isCustom: false, superIndex: 2, isSubEnable: false, title: "培訓", imageLink: "icon_32px_f_l_36", backgroundColor: UIColor.categoryColor3.stringFromUIColor()),
        Category(id: 15, isCustom: false, superIndex: 2, isSubEnable: false, title: "證書", imageLink: "icon_32px_c_l_6", backgroundColor: UIColor.categoryColor3.stringFromUIColor()),
        Category(id: 16, isCustom: false, superIndex: 3, isSubEnable: false, title: "任職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 17, isCustom: false, superIndex: 3, isSubEnable: false, title: "升職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 18, isCustom: false, superIndex: 3, isSubEnable: false, title: "降職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 19, isCustom: false, superIndex: 3, isSubEnable: false, title: "調職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 20, isCustom: false, superIndex: 3, isSubEnable: false, title: "離職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 21, isCustom: false, superIndex: 3, isSubEnable: false, title: "外派", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.categoryColor4.stringFromUIColor()),
        Category(id: 22, isCustom: false, superIndex: 4, isSubEnable: false, title: "運動", imageLink: "icon_32px_f_l_94", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 23, isCustom: false, superIndex: 4, isSubEnable: false, title: "閱讀", imageLink: "icon_32px_c_l_9", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 24, isCustom: false, superIndex: 4, isSubEnable: false, title: "飲食", imageLink: "icon_32px_f_l_1", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 25, isCustom: false, superIndex: 4, isSubEnable: false, title: "旅遊", imageLink: "icon_32px_f_l_38", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 26, isCustom: false, superIndex: 4, isSubEnable: false, title: "才藝", imageLink: "icon_32px_f_l_86", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 27, isCustom: false, superIndex: 4, isSubEnable: false, title: "數位遊戲", imageLink: "icon_32px_f_l_93", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 28, isCustom: false, superIndex: 4, isSubEnable: false, title: "實體遊戲", imageLink: "icon_32px_f_l_96", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 29, isCustom: false, superIndex: 4, isSubEnable: false, title: "多語言", imageLink: "icon_32px_f_l_107", backgroundColor: UIColor.categoryColor5.stringFromUIColor()),
        Category(id: 30, isCustom: false, superIndex: 5, isSubEnable: false, title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor()),
      ]


    case .event:
      filter = ["新關係", "日常互動", "赴約", "衝突", "其他"]
      main = [
        Category(id: 0, isCustom: false, superIndex: 0, isSubEnable: false, title: "偶遇", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 1, isCustom: false, superIndex: 0, isSubEnable: false, title: "同學", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 2, isCustom: false, superIndex: 0, isSubEnable: false, title: "同事", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 3, isCustom: false, superIndex: 0, isSubEnable: false, title: "介紹", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 4, isCustom: false, superIndex: 0, isSubEnable: false, title: "同好", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.categoryColor1.stringFromUIColor()),
        Category(id: 5, isCustom: false, superIndex: 0, isSubEnable: false, title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor()),
        Category(id: 6, isCustom: false, superIndex: 1, isSubEnable: false, title: "閒聊", imageLink: "icon_32px_f_l_107", backgroundColor: UIColor.categoryColor2.stringFromUIColor()),
        Category(id: 7, isCustom: false, superIndex: 1, isSubEnable: false, title: "八卦", imageLink: "icon_32px_f_l_107", backgroundColor: UIColor.categoryColor2.stringFromUIColor()),
        Category(id: 8, isCustom: false, superIndex: 1, isSubEnable: false, title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor()),
        Category(id: 9, isCustom: false, superIndex: 2, isSubEnable: false, title: "聚會", imageLink: "icon_32px_c_l_30", backgroundColor: UIColor.categoryColor3.stringFromUIColor()),
        Category(id: 10, isCustom: false, superIndex: 2, isSubEnable: false, title: "會議", imageLink: "icon_32px_c_l_27", backgroundColor: UIColor.categoryColor3.stringFromUIColor()),
        Category(id: 11, isCustom: false, superIndex: 2, isSubEnable: false, title: "遊戲", imageLink: "icon_32px_f_l_103", backgroundColor: UIColor.categoryColor3.stringFromUIColor()),
        Category(id: 12, isCustom: false, superIndex: 2, isSubEnable: false, title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor()),
        Category(id: 13, isCustom: false, superIndex: 3, isSubEnable: false, title: "誤會", imageLink: "icon_32px_f_l_108", backgroundColor: UIColor.categoryColor8.stringFromUIColor()),
        Category(id: 14, isCustom: false, superIndex: 3, isSubEnable: false, title: "爭執", imageLink: "icon_32px_f_l_108", backgroundColor: UIColor.categoryColor8.stringFromUIColor()),
        Category(id: 15, isCustom: false, superIndex: 3, isSubEnable: false, title: "指責", imageLink: "icon_32px_f_l_108", backgroundColor: UIColor.categoryColor8.stringFromUIColor()),
        Category(id: 16, isCustom: false, superIndex: 3, isSubEnable: false, title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor()),
        Category(id: 17, isCustom: false, superIndex: 4, isSubEnable: false, title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor()),
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

  internal init(id: Int, isCustom: Bool, superIndex: Int, isSubEnable: Bool, title: String, imageLink: String, backgroundColor: String) {
    self.id = id
    self.isCustom = isCustom
    self.superIndex = superIndex
    self.isSubEnable = isSubEnable
    self.title = title
    self.imageLink = imageLink
    self.backgroundColor = backgroundColor
  }

  init() {
    self.id = -1
    self.isCustom = false
    self.superIndex = -1
    self.isSubEnable = false
    self.title = .empty
    self.imageLink = .empty
    self.imageLink = .empty
    self.backgroundColor = .empty
  }

  var id: Int

  var isCustom: Bool

  var superIndex: Int

  var isSubEnable: Bool

  var title: String

  var imageLink: String

  var backgroundColor: String
}

extension Category {
  func isInitialed() -> Bool {
    return id != -1 && superIndex != -1
  }

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

  static func canSubView(type: CategoryType, hierarchy: CategoryHierarchy) -> Bool {

    switch type {
    case .relation:
      if hierarchy == .main {
        return true
      } else {
        return false
      }
    default:
      return false
    }
  }
}
