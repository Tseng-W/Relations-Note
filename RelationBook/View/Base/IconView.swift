//
//  IconView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/28.
//

import UIKit

class IconView: UIImageView {

  func setIcon(image: UIImage, bgColor: UIColor, tintColor: UIColor) {
    self.image = image
    self.backgroundColor = bgColor
    self.tintColor = tintColor
    isCornerd = true
  }
}
