//
//  TutorialContentView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/7/8.
//

import UIKit

class TutorialContentView: UIView, NibLoadable {
  enum TutorialType {
    case person
    case createNote
    case search
    case talking

    var anmation: LottieWrapper.Animation {
      switch self {
      case .createNote:
        return .createNote
      case .person:
        return .person
      case .search:
        return .search
      case .talking:
        return .talking
      }
    }

    var title: String {
      switch self {
      case .talking:
        return "我們常與人交流互動"
      case .search:
        return "記憶越來越模糊"
      case .createNote:
        return "一鍵開始紀錄事件"
      case .person:
        return "即刻紀錄永存關係"
      }
    }

    var content: String {
      switch self {
      case .talking:
        return "交流知識、探討興趣、閒談過往\n並在互動過程中更了解彼此"
      case .search:
        return "還記得好友最喜歡的餐廳？\n幾年前和閨蜜的那場旅行？\n和另一半的每個紀念日？"
      case .createNote:
        return "趁印象清楚時記下互動的細節\n包括時間、地點、互動原因和心情\n以及對他更深一層的認識"
      case .person:
        return "紀錄事件詳情以外\n他人的資訊會分類並持續更新\n不再擔心忘記重要關係"
      }
    }
  }

  @IBOutlet var lottieImage: UIView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var contentView: UITextView!

  var type: TutorialType? {
    didSet {
      if let type = type {
        LottieWrapper.shared.show(lottieImage, animation: type.anmation)
        titleLabel.text = type.title
        contentView.text = type.content
      }
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  convenience init(_ type: TutorialType) {
    self.init(frame: CGRect.zero)
    self.type = type
  }

  func customInit() {
    loadNibContent()
  }
}
