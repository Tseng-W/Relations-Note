//
//  IconView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/28.
//

import UIKit

class IconView: UIView {

  static let defaultBackgroundColor: UIColor = .systemGray
  static let defaultTintColor: UIColor = .systemGray
  static let defaultImage = UIImage(systemName: "camera")!

  var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = defaultImage
    imageView.backgroundColor = defaultBackgroundColor
    imageView.tintColor = defaultTintColor
    imageView.backgroundColor = .clear
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  func setIcon(isCropped: Bool, image: UIImage? = nil, bgColor: UIColor? = nil, borderWidth: CGFloat? = nil, borderColor: UIColor? = nil, tintColor: UIColor? = nil, multiple: CGFloat? = nil) {

    imageView.removeFromSuperview()
    addSubview(imageView)
    imageView.constraints.forEach { $0.isActive = false }

    if let image = image {
      imageView.image = image
    }

    if let bgColor = bgColor {
      backgroundColor = bgColor
      imageView.backgroundColor = bgColor
    }

    if let borderWidth = borderWidth {
      layer.borderWidth = borderWidth
    }

    if let borderColor = borderColor {
      layer.borderColor = borderColor.cgColor
    }

    if let tintColor = tintColor {
      imageView.tintColor = tintColor
    }

    layoutIfNeeded()

    let defaultMultiple: CGFloat = isCropped ? 1 : 0.8

    let iconMultiple: CGFloat = multiple ?? defaultMultiple

    imageView.addConstarint(centerX: centerXAnchor, centerY: centerYAnchor)
    NSLayoutConstraint.activate([
      NSLayoutConstraint.init(
        item: imageView, attribute: .height,
        relatedBy: .equal, toItem: self,
        attribute: .height, multiplier: iconMultiple,
        constant: 0),
      NSLayoutConstraint.init(
        item: imageView, attribute: .width,
        relatedBy: .equal, toItem: self,
        attribute: .width, multiplier: iconMultiple,
        constant: 0)
    ])

    isCornerd = true
    imageView.isCornerd = isCropped
    layoutIfNeeded()
  }
}
