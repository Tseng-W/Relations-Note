//
//  IconViewModel.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/2.
//

import UIKit

class IconViewModel {

  typealias titledImages = [(title: String, images: [UIImage])]

  var iconSets = titledImages()

  init(type: CategoryType) {

    switch type {
    case .relation:
      let lineIcons = fetchLocalIcons(in: LocalIconRelationLine.self)
      iconSets.append(("線條圖示", lineIcons))

      let colorIcons = fetchLocalIcons(in: LocalIconRelationColor.self)
      iconSets.append(("彩色圖示", colorIcons))
    case .event:
      break
    case .feature:
      break
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

  private func fetchLocalIcons<E: RawRepresentable & CaseIterable>(in iconEnum: E.Type) -> [UIImage]
  where E.RawValue == String {
    let icons = E.allCases.map { imageName -> UIImage in
      let image = UIImage.asset(imageName)!
      image.accessibilityIdentifier = imageName.rawValue
      return image
    }
    return icons
  }
}
