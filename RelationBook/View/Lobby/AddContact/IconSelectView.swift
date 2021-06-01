//
//  IconSelectView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/23.
//

import UIKit

@IBDesignable
class IconSelectView: UIView, NibLoadable {

  @IBOutlet var iconView: IconView!  {
    didSet {
      let tapGesture = UITapGestureRecognizer(target: self, action: #selector(iconTapped(tapGesture:)))
      tapGesture.numberOfTapsRequired = 1
      tapGesture.numberOfTouchesRequired = 1
      iconView.addGestureRecognizer(tapGesture)
    }
  }

  @IBOutlet var textField: UITextField! {
    didSet {
      textField.delegate = self
    }
  }

  @IBInspectable var placeholder: String = "" {
    didSet {
      textField.placeholder = placeholder
    }
  }

  @IBInspectable var imageBorderWidth: CGFloat = 0 {
    didSet {
      iconView.imageView.borderWidth = imageBorderWidth
    }
  }

  @IBInspectable var imageBorderColor: UIColor = .white {
    didSet {
      iconView.imageView.borderColor = imageBorderColor
    }
  }

  @IBInspectable var image = UIImage.assetSystem(.camera) {
    didSet {
      guard let image = image else { return }
      iconView.imageView.image = image
    }
  }

  @IBInspectable var imageBackgroundColor: UIColor = .systemTeal {
    didSet {
      iconView.imageView.backgroundColor = imageBackgroundColor
    }
  }

  @IBInspectable var imageTintColor: UIColor = .clear {
    didSet {
      iconView.imageView.tintColor = imageTintColor
    }
  }

  var onIconTapped: ((IconView) -> Void)?

  var onEndEditTitle: ((String) -> Void)? {
    didSet {
      image = UIImage.assetSystem(.camera)

      textField.placeholder = placeholder

      guard let image = image else { return }

      iconView.setIcon(isCropped: false, image: image, bgColor: imageBackgroundColor, tintColor: .label)
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

  override class func awakeFromNib() {
    super.awakeFromNib()
  }

  override class func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
  }

  private func customInit() {
    loadNibContent()
  }

  func setUp(text: String? = nil, image: UIImage? = nil, backgroundColor: UIColor? = nil, borderWidth: CGFloat = 0, borderColor: UIColor? = nil, tintColor: UIColor? = nil) {

    if let text = text {
      textField.text = text
    }

    if let image = image {
      self.image = image
    }

    iconView.setIcon(isCropped: true, image: image, bgColor: backgroundColor, borderWidth: borderWidth, borderColor: borderColor, tintColor: tintColor)
  }

  @objc func iconTapped(tapGesture: UITapGestureRecognizer) {
    onIconTapped?(iconView)
  }
}

extension IconSelectView: UITextFieldDelegate {

  func textFieldDidEndEditing(_ textField: UITextField) {

    guard let text = textField.text,
          text != String.empty else { return }

    onEndEditTitle?(text)
  }
}
