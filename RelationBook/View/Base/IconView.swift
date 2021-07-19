//
//  IconView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/28.
//

import UIKit

class IconView: UIView {

  override var frame: CGRect {
    didSet {
      layer.cornerRadius = frame.height / 2
    }
  }

  static let defaultBackgroundColor: UIColor = .background
  static let defaultTintColor: UIColor = .button
  static let defaultImage = UIImage(systemName: "camera") ?? UIImage()

  var animationView = LottieWrapper()

  var imageView: UIImageView = {
    let imageView = UIImageView()

    imageView.image = defaultImage
    imageView.backgroundColor = defaultBackgroundColor
    imageView.tintColor = defaultTintColor
    imageView.backgroundColor = .clear
    imageView.contentMode = .scaleAspectFit

    return imageView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)

    animationView.show(self, animation: .loading, isCorned: true, multiple: 0.4)
  }

  convenience init() {
    self.init(frame: CGRect())

    animationView.show(self, animation: .loading, isCorned: true, multiple: 0.4)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    animationView.show(self, animation: .loading, isCorned: true, multiple: 0.4)
  }

  func setIcon(
    isCropped: Bool,
    image: UIImage? = nil,
    bgColor: UIColor? = nil,
    borderWidth: CGFloat? = nil,
    borderColor: UIColor? = nil,
    tintColor: UIColor? = .background,
    multiple: CGFloat? = nil
  ) {
    imageView.removeFromSuperview()
    addSubview(imageView)
    imageView.constraints.forEach { $0.isActive = false }

    if let image = image {
      if image.description.contains("_l_") {
        imageView.image = image.withRenderingMode(.alwaysTemplate)
      } else {
        imageView.image = image
      }
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

    setNeedsLayout()
    layoutIfNeeded()

    let defaultMultiple: CGFloat = isCropped ? 1 : 0.6

    let iconMultiple: CGFloat = multiple ?? defaultMultiple

    imageView.addConstarint(centerX: centerXAnchor, centerY: centerYAnchor)

    imageView.addConstarint(relatedBy: self, widthMultiplier: iconMultiple, heightMultiplier: iconMultiple)

    isCornerd = true
//    layer.masksToBounds = true
    imageView.isCornerd = isCropped

    animationView.leave()

    setNeedsLayout()
    layoutIfNeeded()
  }
}
