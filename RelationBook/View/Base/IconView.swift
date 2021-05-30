//
//  IconView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/28.
//

import UIKit

class IconView: UIView {

  var imageView = UIImageView()

  func setIcon(image: UIImage, bgColor: UIColor, tintColor: UIColor) {

    addSubview(imageView)
    imageView.addConstarint(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)

    layoutIfNeeded()
    imageView.image = image
    imageView.backgroundColor = .clear
    imageView.tintColor = tintColor
    imageView.isCornerd = true
    isCornerd = true
    backgroundColor = bgColor
  }
}
