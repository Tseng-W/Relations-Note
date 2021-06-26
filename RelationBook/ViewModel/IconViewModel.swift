//
//  IconViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/2.
//

import UIKit

class IconViewModel {
  typealias TitledImages = [(title: String, images: [UIImage])]

  var iconSets = TitledImages()

  init(type: CategoryType, hierachy: CategoryHierarchy? = nil) {
    switch type {
    case .relation:
      if hierachy == .main {
        let lineIcons = localIconRelationCategoryLine
        iconSets.append(("線性圖示", lineIcons))

        let colorIcons = localIconEventFeatureColor
        iconSets.append(("彩色圖示", colorIcons))
      } else {
        let lineIcons = localIconRelationLine
        iconSets.append(("線性圖示", lineIcons))

        let colorIcons = localIconRelationColor
        iconSets.append(("彩色圖示", colorIcons))
      }
    case .event, .feature:
      let lineIcons = localIconEventFeatureLine
      iconSets.append(("線性圖示", lineIcons))

      let colorIcons = localIconEventFeatureColor
      iconSets.append(("彩色圖示", colorIcons))

    case .mood:
      iconSets.append(("情緒", iconEmoji))
    }
  }

  func searchIconImage(indexPath: IndexPath) -> UIImage? {
    return searchIconImage(set: indexPath.section, index: indexPath.row)
  }

  func searchIconImage(set: Int, index: Int) -> UIImage? {
    guard set < iconSets.count,
          index < iconSets[set].images.count else { return nil }
    return iconSets[set].images[index]
  }

  func searchIconImageString(indexPath: IndexPath) -> String? {
    return searchIconImageString(set: indexPath.section, index: indexPath.row)
  }

  func searchIconImageString(set: Int, index: Int) -> String? {
    guard set < iconSets.count,
          index < iconSets[set].images.count else { return nil }
    return iconSets[set].images[index].accessibilityIdentifier
  }

//  private func fetchLocalIcons<E: RawRepresentable & CaseIterable>(in iconEnum: E.Type) -> [UIImage]
//  where E.RawValue == String {
//    let icons = E.allCases.map { imageName -> UIImage in
//      let image = UIImage.asset(imageName) ?? UIImage()
//      image.accessibilityIdentifier = imageName.rawValue
//      return image
//    }
//    return icons
//  }

  private func fetchImages(names: [String]) -> [UIImage] {
    let icons = names.map { imageName -> UIImage in
      let image = UIImage(named: imageName) ?? UIImage()
      image.accessibilityIdentifier = imageName
      return image
    }
    return icons
  }
}
