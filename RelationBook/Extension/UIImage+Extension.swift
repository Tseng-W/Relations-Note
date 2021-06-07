//
//  UIImage+Extension.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

enum ImageAsset: String {

  // MARK: Main Icons
  case icon = "icon_1024px_icon_nobg"
  case pen = "icon_24px_pen"
  case note = "icon_24px_note"
  case category = "icon_24px_category"
  case profile = "icon_24px_profile"
}

enum Placeholder: String {
  case event = "icon_128px_talk,icon_128px_talk_w"
  case profile = "icon_128px_profile,icon_128px_profile_w"
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

enum LocalRelationIconColor: String, CaseIterable {
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

enum LocalRelationIconLine: String, CaseIterable {
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

enum LocalRelationCategoryLine: String, CaseIterable {
  case r1 = "icon_32px_c_l_1"
  case r2 = "icon_32px_c_l_2"
  case r3 = "icon_32px_c_l_3"
  case r4 = "icon_32px_c_l_4"
  case r5 = "icon_32px_c_l_5"
  case r6 = "icon_32px_c_l_6"
  case r7 = "icon_32px_c_l_7"
  case r8 = "icon_32px_c_l_8"
  case r9 = "icon_32px_c_l_9"
  case r10 = "icon_32px_c_l_10"
  case r11 = "icon_32px_c_l_11"
  case r12 = "icon_32px_c_l_12"
  case r13 = "icon_32px_c_l_13"
  case r14 = "icon_32px_c_l_14"
  case r15 = "icon_32px_c_l_15"
  case r16 = "icon_32px_c_l_16"
  case r17 = "icon_32px_c_l_17"
  case r18 = "icon_32px_c_l_18"
  case r19 = "icon_32px_c_l_19"
  case r20 = "icon_32px_c_l_20"
  case r21 = "icon_32px_c_l_21"
  case r22 = "icon_32px_c_l_22"
  case r23 = "icon_32px_c_l_23"
  case r24 = "icon_32px_c_l_24"
  case r25 = "icon_32px_c_l_25"
  case r26 = "icon_32px_c_l_26"
  case r27 = "icon_32px_c_l_27"
  case r28 = "icon_32px_c_l_28"
  case r29 = "icon_32px_c_l_29"
  case r30 = "icon_32px_c_l_30"
  case r31 = "icon_32px_c_l_31"
  case r32 = "icon_32px_c_l_32"
  case r33 = "icon_32px_c_l_33"
  case r34 = "icon_32px_c_l_34"
  case r35 = "icon_32px_c_l_35"
  case r36 = "icon_32px_c_l_36"
}

enum LocalRelationCategoryColor: String, CaseIterable {
  case r1 = ""
}

enum LocalIconEventFeatureLine: String, CaseIterable {
  case r1 = "icon_32px_f_l_1"
  case r2 = "icon_32px_f_l_2"
  case r3 = "icon_32px_f_l_3"
  case r4 = "icon_32px_f_l_4"
  case r5 = "icon_32px_f_l_5"
  case r6 = "icon_32px_f_l_6"
  case r7 = "icon_32px_f_l_7"
  case r8 = "icon_32px_f_l_8"
  case r9 = "icon_32px_f_l_9"
  case r10 = "icon_32px_f_l_10"
  case r11 = "icon_32px_f_l_11"
  case r12 = "icon_32px_f_l_12"
  case r13 = "icon_32px_f_l_13"
  case r14 = "icon_32px_f_l_14"
  case r15 = "icon_32px_f_l_15"
  case r16 = "icon_32px_f_l_16"
  case r17 = "icon_32px_f_l_17"
  case r18 = "icon_32px_f_l_18"
  case r19 = "icon_32px_f_l_19"
  case r20 = "icon_32px_f_l_20"
  case r21 = "icon_32px_f_l_21"
  case r22 = "icon_32px_f_l_22"
  case r23 = "icon_32px_f_l_23"
  case r24 = "icon_32px_f_l_24"
  case r25 = "icon_32px_f_l_25"
  case r26 = "icon_32px_f_l_26"
  case r27 = "icon_32px_f_l_27"
  case r28 = "icon_32px_f_l_28"
  case r29 = "icon_32px_f_l_29"
  case r30 = "icon_32px_f_l_30"
  case r31 = "icon_32px_f_l_31"
  case r32 = "icon_32px_f_l_32"
  case r33 = "icon_32px_f_l_33"
  case r34 = "icon_32px_f_l_34"
  case r35 = "icon_32px_f_l_35"
  case r36 = "icon_32px_f_l_36"
  case r37 = "icon_32px_f_l_37"
  case r38 = "icon_32px_f_l_38"
  case r39 = "icon_32px_f_l_39"
  case r40 = "icon_32px_f_l_40"
  case r41 = "icon_32px_f_l_41"
  case r42 = "icon_32px_f_l_42"
  case r43 = "icon_32px_f_l_43"
  case r44 = "icon_32px_f_l_44"
  case r45 = "icon_32px_f_l_45"
  case r46 = "icon_32px_f_l_46"
  case r47 = "icon_32px_f_l_47"
  case r48 = "icon_32px_f_l_48"
  case r49 = "icon_32px_f_l_49"
  case r50 = "icon_32px_f_l_50"
  case r51 = "icon_32px_f_l_51"
  case r52 = "icon_32px_f_l_52"
  case r53 = "icon_32px_f_l_53"
  case r54 = "icon_32px_f_l_54"
  case r55 = "icon_32px_f_l_55"
  case r56 = "icon_32px_f_l_56"
  case r57 = "icon_32px_f_l_57"
  case r58 = "icon_32px_f_l_58"
  case r59 = "icon_32px_f_l_59"
  case r60 = "icon_32px_f_l_60"
  case r61 = "icon_32px_f_l_61"
  case r62 = "icon_32px_f_l_62"
  case r63 = "icon_32px_f_l_63"
  case r64 = "icon_32px_f_l_64"
  case r65 = "icon_32px_f_l_65"
  case r66 = "icon_32px_f_l_66"
  case r67 = "icon_32px_f_l_67"
  case r68 = "icon_32px_f_l_68"
  case r69 = "icon_32px_f_l_69"
  case r70 = "icon_32px_f_l_70"
  case r71 = "icon_32px_f_l_71"
  case r72 = "icon_32px_f_l_72"
  case r73 = "icon_32px_f_l_73"
  case r74 = "icon_32px_f_l_74"
  case r75 = "icon_32px_f_l_75"
  case r76 = "icon_32px_f_l_76"
  case r77 = "icon_32px_f_l_77"
  case r78 = "icon_32px_f_l_78"
  case r79 = "icon_32px_f_l_79"
  case r80 = "icon_32px_f_l_80"
  case r81 = "icon_32px_f_l_81"
  case r82 = "icon_32px_f_l_82"
  case r83 = "icon_32px_f_l_83"
  case r84 = "icon_32px_f_l_84"
  case r85 = "icon_32px_f_l_85"
  case r86 = "icon_32px_f_l_86"
  case r87 = "icon_32px_f_l_87"
  case r88 = "icon_32px_f_l_88"
  case r89 = "icon_32px_f_l_89"
  case r90 = "icon_32px_f_l_90"
  case r91 = "icon_32px_f_l_91"
  case r92 = "icon_32px_f_l_92"
  case r93 = "icon_32px_f_l_93"
  case r94 = "icon_32px_f_l_94"
  case r95 = "icon_32px_f_l_95"
  case r96 = "icon_32px_f_l_96"
  case r97 = "icon_32px_f_l_97"
  case r98 = "icon_32px_f_l_98"
  case r99 = "icon_32px_f_l_99"
  case r100 = "icon_32px_f_l_100"
  case r101 = "icon_32px_f_l_101"
  case r102 = "icon_32px_f_l_102"
  case r103 = "icon_32px_f_l_103"
  case r104 = "icon_32px_f_l_104"
  case r105 = "icon_32px_f_l_105"
}

enum SysetmAsset: String {
  // tabItems
  case add = "plus"
  case add_fill = "plus_fill"
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

  static func getPlaceholder(_ placeholder: Placeholder, style: UIUserInterfaceStyle) -> UIImage {

    let imageString = placeholder.rawValue.split(separator: ",")

    switch style {
    case .light:
      return UIImage(named: String(imageString[0]))!
    default:
      return UIImage(named: String(imageString[1]))!
    }
  }
}
