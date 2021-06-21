//
//  LocalIconSelectionView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/2.
//

import UIKit

class LocalIconSelectionViewCell: UICollectionViewCell {

  @IBOutlet var iconView: IconView!

  func setImage(image: UIImage) {
    iconView.setIcon(isCropped: false, image: image, bgColor: .clear)
  }
}
