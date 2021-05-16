//
//  UIView+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import UIKit

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
