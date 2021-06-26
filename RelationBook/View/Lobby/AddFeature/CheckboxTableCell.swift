//
//  checkboxTableCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/25.
//

import UIKit

class CheckboxTableCell: UITableViewCell {

  let placeholder: String = "新增"
  let placeholderColor: UIColor = .buttonDisable

  var content = FeatureContent(isProcessing: true, text: "") {
    didSet {
      checkmarkButton.isSelected = content.isProcessing
      inputTextField.text = content.text
    }
  }

  @IBOutlet var checkmarkButton: UIButton! {
    didSet {
      checkmarkButton.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
      checkmarkButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
    }
  }

  @IBOutlet var inputTextField: UITextField! {
    didSet {
      inputTextField.delegate = self
    }
  }

  var onEndEdit: ((UITableViewCell, FeatureContent) -> Void)?

  override func prepareForReuse() {
    super.prepareForReuse()
    inputTextField.text = String.empty
  }

  func setup(content: FeatureContent?) {
    guard let content = content else {
//      checkmarkButton.isHidden = true
      return
    }

    self.content = content
//    checkmarkButton.isHidden = false
  }

  @IBAction func onTapSwitch(_ sender: UIButton) {
    content.isProcessing.toggle()
    checkmarkButton.isSelected = content.isProcessing
  }
}

extension CheckboxTableCell: UITextFieldDelegate {
  func textFieldDidEndEditing(_ textField: UITextField) {
    guard let text = textField.text,
          text.isEmpty == false else { return }

    content.text = text
    onEndEdit?(self, content)
  }
}
