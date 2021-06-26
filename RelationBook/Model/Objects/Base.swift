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

  struct CategoryData {
    var title: String
    var imageLink: String
    var backgroundColor: String
  }

  var type: CategoryType

  var filter: [String] = []

  var main: [Category] = []

  var sub: [Category] = []

  init(type: CategoryType) {
    self.type = type
    switch type {
    case .relation:
      initialDefaultRelationCategory()

    case .feature:
      initialDefaultFeatureCategory()

    case .event:
      initialDefaultEventCategory()
    }
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
    return [
      "filter": filter,
      "main": main.compactMap { category in category.toDict() },
      "sub": sub.compactMap { category in category.toDict() },
      "type": type.rawValue
    ]
  }

  private func initialDefaultRelationCategory() {
    filter = ["家庭成員", "閨蜜死黨", "同儕好友", "導師前輩", "同事下屬", "鄰里住居", "親暱關係", "結拜關係", "其他"]
    let mainData = [
      [
        CategoryData(title: "祖父母", imageLink: "icon_32px_c_l_17", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "父母", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "叔叔姑姑", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "兄弟姐妹", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "姪子姪女", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "夫妻", imageLink: "icon_32px_c_l_18", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "子女", imageLink: "icon_32px_c_l_15", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "孫子孫女", imageLink: "icon_32px_c_l_15", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "遠親", imageLink: "icon_32px_c_l_13", backgroundColor: UIColor.color1.stringFromUIColor())
      ],
      [
        CategoryData(title: "閨蜜", imageLink: "icon_32px_c_l_19", backgroundColor: UIColor.color9.stringFromUIColor()),
        CategoryData(title: "死黨", imageLink: "icon_32px_c_l_19", backgroundColor: UIColor.color9.stringFromUIColor())
      ],
      [
        CategoryData(title: "學長姐", imageLink: "icon_32px_c_l_25", backgroundColor: UIColor.color2.stringFromUIColor()),
        CategoryData(title: "學弟妹", imageLink: "icon_32px_c_l_25", backgroundColor: UIColor.color2.stringFromUIColor()),
        CategoryData(title: "社團好友", imageLink: "icon_32px_c_l_25", backgroundColor: UIColor.color2.stringFromUIColor())
      ],
      [
        CategoryData(title: "老師", imageLink: "icon_32px_c_l_8", backgroundColor: UIColor.color3.stringFromUIColor()),
        CategoryData(title: "學生", imageLink: "icon_32px_c_l_8", backgroundColor: UIColor.color3.stringFromUIColor())
      ],
      [
        CategoryData(title: "老闆", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "主管", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "同事", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "前老闆", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "前主管", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "前同事", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor())
      ],
      [
        CategoryData(title: "鄰居", imageLink: "icon_32px_c_l_33", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "房東", imageLink: "icon_32px_c_l_33", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "房客", imageLink: "icon_32px_c_l_33", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "同居人", imageLink: "icon_32px_c_l_33", backgroundColor: UIColor.color5.stringFromUIColor())
      ],
      [
        CategoryData(title: "男女朋友", imageLink: "icon_32px_c_l_18", backgroundColor: UIColor.color6.stringFromUIColor()),
        CategoryData(title: "前男女朋友", imageLink: "icon_32px_c_l_18", backgroundColor: UIColor.color6.stringFromUIColor()),
        CategoryData(title: "老友", imageLink: "icon_32px_c_l_23", backgroundColor: UIColor.color6.stringFromUIColor())
      ],
      [
        CategoryData(title: "乾爹乾媽", imageLink: "icon_32px_c_l_24", backgroundColor: UIColor.color7.stringFromUIColor()),
        CategoryData(title: "乾兄弟", imageLink: "icon_32px_c_l_24", backgroundColor: UIColor.color7.stringFromUIColor()),
        CategoryData(title: "乾姐妹", imageLink: "icon_32px_c_l_24", backgroundColor: UIColor.color7.stringFromUIColor())
      ],
      [
        CategoryData(title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor())
      ]
    ]

    main = convertDateToCategory(data: mainData, isSubEnable: true)
  }

  private func initialDefaultFeatureCategory() {
    filter = ["個人資訊", "情感狀態", "學習歷程", "職涯發展", "興趣特長", "其他"]

    let mainData = [
      [
        CategoryData(title: "暱稱", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "生理性別", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "電話號碼", imageLink: "icon_32px_f_l_46", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "生日", imageLink: "icon_32px_f_l_26", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "星座", imageLink: "icon_32px_f_l_106", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "居住地", imageLink: "icon_32px_c_l_12", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "外貌特徵", imageLink: "icon_32px_f_l_65", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "個性", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor())
      ],
      [
        CategoryData(title: "交往", imageLink: "icon_32px_c_l_20", backgroundColor: UIColor.color6.stringFromUIColor()),
        CategoryData(title: "婚嫁", imageLink: "icon_32px_c_l_20", backgroundColor: UIColor.color6.stringFromUIColor())
      ],
      [
        CategoryData(title: "畢業", imageLink: "icon_32px_c_l_6", backgroundColor: UIColor.color3.stringFromUIColor()),
        CategoryData(title: "休學", imageLink: "icon_32px_c_l_6", backgroundColor: UIColor.color3.stringFromUIColor()),
        CategoryData(title: "培訓", imageLink: "icon_32px_f_l_36", backgroundColor: UIColor.color3.stringFromUIColor()),
        CategoryData(title: "證書", imageLink: "icon_32px_c_l_6", backgroundColor: UIColor.color3.stringFromUIColor())
      ],
      [
        CategoryData(title: "任職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "升職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "降職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "調職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "離職", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor()),
        CategoryData(title: "外派", imageLink: "icon_32px_c_l_26", backgroundColor: UIColor.color4.stringFromUIColor())
      ],
      [
        CategoryData(title: "運動", imageLink: "icon_32px_f_l_94", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "閱讀", imageLink: "icon_32px_c_l_9", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "飲食", imageLink: "icon_32px_f_l_1", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "旅遊", imageLink: "icon_32px_f_l_38", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "才藝", imageLink: "icon_32px_f_l_86", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "數位遊戲", imageLink: "icon_32px_f_l_93", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "實體遊戲", imageLink: "icon_32px_f_l_96", backgroundColor: UIColor.color5.stringFromUIColor()),
        CategoryData(title: "多語言", imageLink: "icon_32px_f_l_107", backgroundColor: UIColor.color5.stringFromUIColor())
      ],
      [
        CategoryData(title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor())
      ]
    ]

    main = convertDateToCategory(data: mainData, isSubEnable: false)
  }

  private func initialDefaultEventCategory() {
    filter = ["新關係", "日常互動", "赴約", "衝突", "其他"]

    let mainData = [
      [
        CategoryData(title: "偶遇", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "同學", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "同事", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "介紹", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "同好", imageLink: "icon_32px_f_l_45", backgroundColor: UIColor.color1.stringFromUIColor()),
        CategoryData(title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor())
      ],
      [
        CategoryData(title: "閒聊", imageLink: "icon_32px_f_l_107", backgroundColor: UIColor.color2.stringFromUIColor()),
        CategoryData(title: "八卦", imageLink: "icon_32px_f_l_107", backgroundColor: UIColor.color2.stringFromUIColor()),
        CategoryData(title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor())
      ],
      [
        CategoryData(title: "聚會", imageLink: "icon_32px_c_l_30", backgroundColor: UIColor.color3.stringFromUIColor()),
        CategoryData(title: "會議", imageLink: "icon_32px_c_l_27", backgroundColor: UIColor.color3.stringFromUIColor()),
        CategoryData(title: "遊戲", imageLink: "icon_32px_f_l_103", backgroundColor: UIColor.color3.stringFromUIColor()),
        CategoryData(title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor())
      ],
      [
        CategoryData(title: "誤會", imageLink: "icon_32px_f_l_108", backgroundColor: UIColor.color8.stringFromUIColor()),
        CategoryData(title: "爭執", imageLink: "icon_32px_f_l_108", backgroundColor: UIColor.color8.stringFromUIColor()),
        CategoryData(title: "指責", imageLink: "icon_32px_f_l_108", backgroundColor: UIColor.color8.stringFromUIColor()),
        CategoryData(title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor())
      ],
      [
        CategoryData(title: "其他", imageLink: "ellipsis", backgroundColor: UIColor.systemGray.stringFromUIColor())
      ]
    ]

    main = convertDateToCategory(data: mainData, isSubEnable: false)
  }

  private func convertDateToCategory(data: [[CategoryData]], isSubEnable: Bool) -> [Category] {
    var id = 0
    var result: [Category] = []

    for filterIndex in 0..<data.count {
      for index in 0..<data[filterIndex].count {
        let source = data[filterIndex][index]
        result.append(Category(
                        id: id,
                        isCustom: false,
                        superIndex: filterIndex,
                        isSubEnable: isSubEnable,
                        title: source.title,
                        imageLink: source.imageLink,
                        backgroundColor: source.backgroundColor))
        id += 1
      }
    }

    return result
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
