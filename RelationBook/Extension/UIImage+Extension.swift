//
//  UIImage+Extension.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

enum ImageAsset: String {
  
  case icon = "icon_24px_icon"
  case pen = "icon_24px_pen"
  case note = "icon_24px_note"
  case category = "icon_24px_category"
  case profile = "icon_24px_profile"
  case emojiAngry = "icon_32px_angry"
  case emojiConfused = "icon_32px_confused"
  case emojiGrin = "icon_32px_grin"
  case emojiHappy = "icon_32px_happy"
  case emojiLove = "icon_32px_love"
  case emojiSad = "icon_32px_sad"
  case emojiSleeping = "icon_32px_sleeping"
  case emojiWaiting = "icon_32px_waiting"
  case emojiWinking = "icon_32px_winking"
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
  case camera = "camera"
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
