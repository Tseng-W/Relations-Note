//
//  TitledInputTableCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/23.
//

import UIKit
import SwiftyMenu

protocol TitledInputDelegate: AnyObject {
  func selectBarItemsTitle(bar: TitledInputView) -> [SwiftyMenuDisplayable]
}

@IBDesignable
class TitledInputView: UIView, NibLoadable {

  enum InputType: Int {
    case textField = 0
  }

  @IBInspectable var title: String = "Title" {
    didSet {
      titleLabel.text = title
    }
  }
  @IBOutlet var textField: UITextField!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var selectBar: SwiftyMenu! {
    didSet {
      selectBar.delegate = self
    }
  }

  weak var delegate: TitledInputDelegate?

  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  override class func awakeFromNib() {
    super.awakeFromNib()
  }

  override class func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
  }

  private func customInit() {
    loadNibContent()
    textField.text = title

    if let items = delegate?.selectBarItemsTitle(bar: self) {
      selectBar.items = items
    }
  }
}

extension TitledInputView: SwiftyMenuDelegate {

  func swiftyMenu(_ swiftyMenu: SwiftyMenu, didSelectItem item: SwiftyMenuDisplayable, atIndex index: Int) {
  }
}
