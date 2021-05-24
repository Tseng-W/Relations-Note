//
//  IconSelectView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/23.
//

import UIKit

@IBDesignable
class IconSelectView: UIView, NibLoadable {

  @IBInspectable var placeholder: String = "" {
    didSet {
      textField.placeholder = placeholder
    }
  }

  @IBInspectable var image: UIImage? = nil {
    didSet {
      guard let image = image else { return }
      iconImageView.image = image
    }
  }

  @IBInspectable var imageBackgroundColor: UIColor = .clear {
    didSet {
      iconImageView.backgroundColor = imageBackgroundColor
    }
  }

  @IBInspectable var imageTintColor: UIColor = .clear {
    didSet {
      iconImageView.tintColor = imageTintColor
    }
  }

  @IBOutlet var iconImageView: UIImageView!
  @IBOutlet var textField: UITextField!

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
    textField.placeholder = placeholder
    iconImageView.backgroundColor = imageBackgroundColor
    iconImageView.tintColor = imageTintColor
  }
}
