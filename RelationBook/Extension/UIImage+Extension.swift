//
//  UIImage+Extension.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

enum ImageAsset: String {

  // MARK: Main Icons
  case icon = "icon_24px_icon"
  case pen = "icon_24px_pen"
  case note = "icon_24px_note"
  case category = "icon_24px_category"
  case profile = "icon_24px_profile"
  case talkPH = "icon_128px_talk"
  case talkPHWhite = "icon_128px_talk_w"
}

enum EmojiIcon: String, CaseIterable {
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

enum LocalIconRelationColor: String, CaseIterable {
  case r1 = "icon_32px_r_1"
  case r2 = "icon_32px_r_2"
  case r3 = "icon_32px_r_3"
  case r4 = "icon_32px_r_4"
  case r5 = "icon_32px_r_5"
  case r6 = "icon_32px_r_6"
  case r7 = "icon_32px_r_7"
  case r8 = "icon_32px_r_8"
  case r9 = "icon_32px_r_9"
  case r10 = "icon_32px_r_10"
  case r11 = "icon_32px_r_11"
  case r12 = "icon_32px_r_12"
  case r13 = "icon_32px_r_13"
  case r14 = "icon_32px_r_14"
  case r15 = "icon_32px_r_15"
  case r16 = "icon_32px_r_16"
  case r17 = "icon_32px_r_17"
  case r18 = "icon_32px_r_18"
  case r19 = "icon_32px_r_19"
  case r20 = "icon_32px_r_20"
  case r21 = "icon_32px_r_21"
  case r22 = "icon_32px_r_22"
  case r23 = "icon_32px_r_23"
  case r24 = "icon_32px_r_24"
  case r25 = "icon_32px_r_25"
  case r26 = "icon_32px_r_26"
  case r27 = "icon_32px_r_27"
  case r28 = "icon_32px_r_28"
  case r29 = "icon_32px_r_29"
  case r30 = "icon_32px_r_30"
}

enum LocalIconRelationLine: String, CaseIterable {
  case r1 = "icon_32px_r_l_1"
  case r2 = "icon_32px_r_l_2"
  case r3 = "icon_32px_r_l_3"
  case r4 = "icon_32px_r_l_4"
  case r5 = "icon_32px_r_l_5"
  case r6 = "icon_32px_r_l_6"
  case r7 = "icon_32px_r_l_7"
  case r8 = "icon_32px_r_l_8"
  case r9 = "icon_32px_r_l_9"
  case r10 = "icon_32px_r_l_10"
  case r11 = "icon_32px_r_l_11"
  case r12 = "icon_32px_r_l_12"
  case r13 = "icon_32px_r_l_13"
  case r14 = "icon_32px_r_l_14"
  case r15 = "icon_32px_r_l_15"
  case r16 = "icon_32px_r_l_16"
  case r17 = "icon_32px_r_l_17"
  case r18 = "icon_32px_r_l_18"
  case r19 = "icon_32px_r_l_19"
  case r20 = "icon_32px_r_l_20"
  case r21 = "icon_32px_r_l_21"
  case r22 = "icon_32px_r_l_22"
  case r23 = "icon_32px_r_l_23"
  case r24 = "icon_32px_r_l_24"
  case r25 = "icon_32px_r_l_25"
  case r26 = "icon_32px_r_l_26"
  case r27 = "icon_32px_r_l_27"
  case r28 = "icon_32px_r_l_28"
  case r29 = "icon_32px_r_l_29"
  case r30 = "icon_32px_r_l_30"
  case r31 = "icon_32px_r_l_31"
}

enum LocalIconEvent: String, CaseIterable {
  case test = "asd"
}

enum LocalIconFeature: String, CaseIterable {
  case test = "asd"
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

  static func asset<E: RawRepresentable>(_ asset: E) -> UIImage? where E.RawValue == String {
    return UIImage(named: asset.rawValue)
  }
  
  static func assetSystem<E: RawRepresentable>(_ asset: E) -> UIImage? where E.RawValue == String {
    return UIImage(systemName: asset.rawValue)
  }

  func toString() -> String? {
    let data: Data? = self.pngData()
    return data?.base64EncodedString(options: .endLineWithLineFeed)
  }
}
