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
    case trigger
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
      editButton.superview?.isHidden = status == .add

      editButton.isHidden = status != .edit
      editButton.isUserInteractionEnabled = status != .trigger

      if status == .trigger {

        let switchView = UISwitch(frame: .zero)

        switchView.onTintColor = .button
        switchView.tintColor = .background

        let style = window?.overrideUserInterfaceStyle

        switchView.setOn(style == .dark, animated: true)
        switchView.addTarget(self, action: #selector(self.onSwitchTapped(_:)), for: .valueChanged)
        accessoryView = switchView

        contentView.superview?.backgroundColor = .background
      }
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
  
  @objc func onSwitchTapped(_ sender: UISwitch) {
    window?.overrideUserInterfaceStyle = sender.isOn ? .dark : .light

    if sender.isOn {
      UserDefaults.standard.setValue(
        "dark",
        forKey: UserDefaults.Keys.style.rawValue)
    } else {
      UserDefaults.standard.setValue(
        "light",
        forKey: UserDefaults.Keys.style.rawValue)
    }

  }
}
