//
//  TitledInputView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/24.
//

import UIKit

@IBDesignable
class AddFeatureTableCell: UITableViewCell {

  enum CellStatus {
    case add
    case edit
  }

  @IBInspectable var placeholder: String = "點擊選擇" {
    didSet {
      button.setTitle(placeholder, for: .normal)
    }
  }
  @IBInspectable var title: String = "標題" {
    didSet {
      titleLabel.text = title
    }
  }

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var button: UIButton!
  @IBOutlet var addButton: UIButton!


  var status: CellStatus = .add {
    didSet {
      addButton.isHidden = status == .add
      titleLabel.isHidden = status == .edit
      button.isHidden = status == .edit
    }
  }
  var selectedContent: String? {
    didSet {
      button.setTitle(selectedContent, for: .normal)
      button.setTitleColor(.secondaryLabel, for: .normal)
    }
  }

  var onTapped: (() -> Void)?

  func customInit() {
    titleLabel.text = title
    button.setTitle(placeholder, for: .normal)
  }

  func setType(status: CellStatus, title: String? = .empty, subTitle: String? = .empty) {
    self.status = status
    titleLabel.text = title
    button.setTitle(subTitle, for: .normal)
  }

  @IBAction func onTapButton(_ sender: UIButton) {
    onTapped?()
  }
}
