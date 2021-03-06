//
//  PopMoodSelect.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/16.
//

import UIKit

class MoodSelectView: UIView {

  let userViewModel = UserViewModel()

  let collectionView = IconSelectionView()

  var iconViewModel = IconViewModel(type: .mood)
  var iconDetail = UserViewModel.moodData

  var onSelected: ((Int, UIImage, UIColor) -> Void)? {
    didSet {
      setUp()
    }
  }

  private func setUp() {
    addSubview(collectionView)
    collectionView.addConstarint(fill: self)
    collectionView.delegate = self
    collectionView.dataSource = self

    layer.cornerRadius = 16
  }

  @objc private func onTap(_ sender: UIButton) {
  }
}

extension MoodSelectView: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if let titledImage = iconViewModel.iconSets.first {
      return titledImage.images.count
    }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            cell: LocalIconSelectionViewCell.self,
            indexPath: indexPath) else {
      String.trackFailure("dequeueReusableCell failures")
      return LocalIconSelectionViewCell()
    }

    cell.iconView.setIcon(
      isCropped: false,
      image: iconDetail[indexPath.row].image,
      bgColor: UIColor.UIColorFromString(string: iconDetail[indexPath.row].colorString)
    )

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:

      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: String(describing: LocalIconSelectionViewHeader.self),
        for: indexPath)

      if let headerSuperView = header.subviews.first {
        headerSuperView.backgroundColor = .background
      }

      if let header = header as? LocalIconSelectionViewHeader {
        header.titleLabel.text = iconViewModel.iconSets[indexPath.section].title
      }

      return header

    default:
      assertionFailure()
    }

    return UICollectionReusableView()
  }

  func collectionView(_ collectionsView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.cellForItem(at: indexPath)?.isSelected = false

    let moodDetail = iconDetail[indexPath.row]

    onSelected?(indexPath.row, moodDetail.image, UIColor.UIColorFromString(string: moodDetail.colorString))

    removeFromSuperview()
  }
}
