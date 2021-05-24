//
//  TitledInputView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/24.
//

import UIKit

@IBDesignable
class TitledInputView: UIView, NibLoadable {

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

  var onTapped: (() -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  override class func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
  }

  func customInit() {
    loadNibContent()
    titleLabel.text = title
    button.setTitle(placeholder, for: .normal)
  }
  @IBAction func onTapButton(_ sender: UIButton) {
    onTapped?()
  }
}
