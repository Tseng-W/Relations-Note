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
      editButton.setTitle(placeholder, for: .normal)
    }
  }
  @IBInspectable var title: String = "標題" {
    didSet {
      titleLabel.text = title
    }
  }

  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var editButton: UIButton!
  @IBOutlet var addButton: UIButton!


  var status: CellStatus = .add {
    didSet {
      addButton.superview?.isHidden = status != .add
      editButton.superview?.isHidden = status != .edit
    }
  }
  var selectedContent: String? {
    didSet {
      editButton.setTitle(selectedContent, for: .normal)
      editButton.setTitleColor(.secondaryLabel, for: .normal)
    }
  }

  var onTapped: (() -> Void)?

  func customInit() {
    titleLabel.text = title
    editButton.setTitle(placeholder, for: .normal)
  }

  func setType(status: CellStatus, title: String? = .empty, subTitle: String? = .empty) {
    self.status = status
    titleLabel.text = title
    editButton.setTitle(subTitle, for: .normal)
  }
}
