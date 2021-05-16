//
//  UIImage+Extension.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

enum ImageAsset: String {
  
  case none
}

enum SysetmAsset: String {
  // tabItems
  case book
  case book_fill = "book.fill"
  case clock
  case clock_fill = "clock.fill"
  case person
  case preson_fill = "person.fill"
  case person3 = "person.3"
  case person3_fill = "person.3.fill"
  case lobby = "plus"
  case lobby_fill = "plusa"
}

extension UIImage {
  static func asset(_ asset: ImageAsset) -> UIImage? {
    return UIImage(named: asset.rawValue)
  }
  
  static func assetSystem(_ asset: SysetmAsset) -> UIImage? {
    return UIImage(systemName: asset.rawValue)
  }

  func toString() -> String? {
    let data: Data? = self.pngData()
    return data?.base64EncodedString(options: .endLineWithLineFeed)
  }
}


@IBDesignable
extension UIImageView {

  @IBInspectable var isCornerd: Bool {
    set {
      if newValue {
        layer.cornerRadius = frame.size.height / 2
        layer.masksToBounds = true
      }
    }
    get {
      return layer.cornerRadius > 0
    }
  }
}
