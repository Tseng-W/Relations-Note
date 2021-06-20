//
//  UIView+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import UIKit

extension UIView {

  static var rootView: UIView {
    let keyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }

    if let topController = keyWindow?.rootViewController {
      while let presentedViewController = topController.presentedViewController {
        return presentedViewController.view
      }
    }

    return keyWindow!.rootViewController!.view
  }

  var globalFrame: CGRect? {
    return self.superview?.convert(self.frame, to: nil)
  }

  func addBlurView() -> UIVisualEffectView {
    let blurEffect = UIBlurEffect(style: .dark)
    let blurView = UIVisualEffectView(effect: blurEffect)
    addSubview(blurView)
    blurView.addConstarint(
      top: topAnchor,
      left: leftAnchor,
      bottom: bottomAnchor,
      right: rightAnchor)

    return blurView
  }

  func addConstarint(fill view: UIView) {
    addConstarint(
      top: view.topAnchor,
      left: view.leftAnchor,
      bottom: view.bottomAnchor,
      right: view.rightAnchor
    )
  }

  func addConstarint(
    relatedBy: UIView,
    widthMultiplier wMultiplier: CGFloat? = nil,
    widthConstant wConstant: CGFloat = 0,
    heightMultiplier hMultiplier: CGFloat? = nil,
    heightConstant hConstant: CGFloat = 0
  ) {
    if let wMultiplier = wMultiplier {
      self.widthAnchor.constraint(
        equalTo: relatedBy.widthAnchor,
        multiplier: wMultiplier,
        constant: wConstant).isActive = true
    }

    if let hMultiplier = hMultiplier {
      heightAnchor.constraint(
        equalTo: relatedBy.heightAnchor,
        multiplier: hMultiplier,
        constant: hConstant).isActive = true
    }
  }

  func addConstarint(
    top: NSLayoutYAxisAnchor? = nil,
    left: NSLayoutXAxisAnchor? = nil,
    bottom: NSLayoutYAxisAnchor? = nil,
    right: NSLayoutXAxisAnchor? = nil,
    centerX: NSLayoutXAxisAnchor? = nil,
    centerY: NSLayoutYAxisAnchor? = nil,
    paddingTop: CGFloat = 0,
    paddingLeft: CGFloat = 0,
    paddingBottom: CGFloat = 0,
    paddingRight: CGFloat = 0,
    width: CGFloat = 0,
    height: CGFloat = 0
  ) {
    translatesAutoresizingMaskIntoConstraints = false
    // Use the top parameter to set the top constarint
    if let top = top {
      self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    // Use the left parameter to set the left constarint
    if let left = left {
      self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    // Use the bottom parameter to set the bottom constarint
    if let bottom = bottom {
      self.bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    // Use the right parameter to set the right constarint
    if let right = right {
      self.rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }

    // Use the right parameter to set the right constarint
    if let centerX = centerX {
      self.centerXAnchor.constraint(equalTo: centerX, constant: paddingLeft - paddingRight).isActive = true
    }

    // Use the right parameter to set the right constarint
    if let centerY = centerY {
      self.centerYAnchor.constraint(equalTo: centerY, constant: paddingLeft - paddingRight).isActive = true
    }

    // Use the width parameter to set the top constarint
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    // Use the height parameter to set the top constarint
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }

  func addPlaceholder(image: UIImage, description: String) {
    if subviews.first(where: { $0.tag == 999 }) != nil {
      return
    }

    let label = UILabel()
    label.textColor = .button
    label.text = description
    label.textAlignment = .center
    label.tag = 999

    let imageView = UIImageView(image: image)
    imageView.tag = 999

    addSubview(imageView)
    addSubview(label)

    imageView.addConstarint(
      centerX: centerXAnchor,
      centerY: centerYAnchor,
      width: frame.width / 3,
      height: frame.width / 3)
    label.addConstarint(
      top: imageView.bottomAnchor, centerX: centerXAnchor, paddingTop: 16, width: frame.width, height: 30)
  }

  func removePlaceholder() {
    subviews.forEach { view in
      if view.tag == 999 {
        view.removeFromSuperview()
      }
    }
  }
}

@IBDesignable
extension UIView {
  @IBInspectable var isCornerd: Bool {
    set {
      layer.cornerRadius = newValue ? frame.size.height / 2 : 0
      layer.masksToBounds = newValue
    }
    get {
      return layer.cornerRadius > 0
    }
  }

  @IBInspectable var cornerRadius: CGFloat {
    set {
      layer.cornerRadius = newValue
      layer.masksToBounds = newValue > 0
    }

    get {
      layer.cornerRadius
    }
  }

  @IBInspectable var borderWidth: CGFloat {
    set {
      layer.borderWidth = newValue
    }
    get {
      return layer.borderWidth
    }
  }

  @IBInspectable var borderColor: UIColor {
    set {
      layer.borderColor = newValue.cgColor
    }
    get {
      guard let borderColor = layer.borderColor else { return .clear }
      return UIColor(cgColor: borderColor)
    }
  }
}
