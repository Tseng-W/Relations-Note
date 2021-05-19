//
//  UIView+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import UIKit

extension UIView {
  func addConstarint(top: NSLayoutYAxisAnchor?,
                     left: NSLayoutXAxisAnchor?,
                     bottom: NSLayoutYAxisAnchor?,
                     right: NSLayoutXAxisAnchor?,
                     paddingTop: CGFloat,
                     paddingLeft: CGFloat,
                     paddingBottom: CGFloat,
                     paddingRight: CGFloat,
                     width: CGFloat,
                     height: CGFloat) {
    
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
    // Use the width parameter to set the top constarint
    if width != 0 {
      widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    // Use the height parameter to set the top constarint
    if height != 0 {
      heightAnchor.constraint(equalToConstant: height).isActive = true
    }
  }
}

@IBDesignable
extension UIView {
  
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
