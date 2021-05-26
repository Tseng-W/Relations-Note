//
//  checkboxTableCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/25.
//

import UIKit

class CheckboxTableCell: UITableViewCell {

  var content = FeatureContent(isProcessing: false, content: "") {
    didSet {
      checkmarkButton.isSelected = content.isProcessing
      checkmarkButton.setTitle("進行中", for: .normal)
      checkmarkButton.setTitle("已結束", for: .selected)
      inputTextField.text = content.content
    }
  }

  @IBOutlet var checkmarkButton: UIButton! {
    didSet {
      checkmarkButton.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
      checkmarkButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: .selected)
    }
  }

  @IBOutlet var inputTextField: UITextField! {
    didSet {
      inputTextField.delegate = self
    }
  }

  var isProcessing: Bool = false {
    didSet {
      if isProcessing {
        checkmarkButton.setImage(UIImage(systemName: ""), for: .disabled)
      }
    }
  }

  var onEndEdit: ((UITableViewCell, FeatureContent) -> Void)?

  var onSwitchPrecessing: ((UITableViewCell) -> Void)?

  override func prepareForReuse() {
    super.prepareForReuse()
    isProcessing = false
    inputTextField.text = String.empty
  }

  func setup(content: FeatureContent?) {
    if let content = content {
      self.content = content
    }
  }

  @IBAction func onTapSwitch(_ sender: UIButton) {
    onSwitchPrecessing?(self)
  }
}

extension CheckboxTableCell: UITextFieldDelegate {

  func textFieldDidEndEditing(_ textField: UITextField) {

    guard let text = textField.text,
          text.isEmpty == false else { return }

    onEndEdit?(self, content)
  }
}
