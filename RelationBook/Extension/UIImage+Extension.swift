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
  case friend = "icon_128px_friend,icon_128px_friend_w"
}

let iconEmoji = UIImage.loadAssetImagesSequence(name: "icon_32px_emoji_", range: 1...9)

let localIconRelationColor = UIImage.loadAssetImagesSequence(name: "icon_32px_r_", range: 1...30)

let localIconRelationLine = UIImage.loadAssetImagesSequence(name: "icon_32px_r_l_", range: 1...36)

let localIconRelationCategoryLine = UIImage.loadAssetImagesSequence(name: "icon_32px_c_l_", range: 1...36)

let localIconEventFeatureLine = UIImage.loadAssetImagesSequence(name: "icon_32px_f_l_", range: 1...105)

let localIconEventFeatureColor = UIImage.loadAssetImagesSequence(name: "icon_32px_f_c_", range: 1...63)

enum SysetmAsset: String {
  // tabItems
  case add = "plus"
  case camera = "camera"
}

extension UIImage {
  static func asset<E: RawRepresentable>(_ asset: E) -> UIImage? where E.RawValue == String {
    return UIImage(named: asset.rawValue)
  }

  static func assetSystem<E: RawRepresentable>(_ asset: E) -> UIImage? where E.RawValue == String {
    return UIImage(systemName: asset.rawValue)
  }

  static func loadAssetImagesSequence(name: String, range: ClosedRange<Int>) -> [UIImage] {
    return range.map { index in
      return UIImage(named: name + "\(index)") ?? UIImage()
    }
  }

  func toString() -> String? {
    let data: Data? = self.pngData()
    return data?.base64EncodedString(options: .endLineWithLineFeed)
  }

  static func getPlaceholder(_ placeholder: Placeholder, style: UIUserInterfaceStyle) -> UIImage {
    let imageString = placeholder.rawValue.split(separator: ",")

    switch style {
    case .light:
      return UIImage(named: String(imageString[0])) ?? UIImage()
    default:
      return UIImage(named: String(imageString[1])) ?? UIImage()
    }
  }
}
