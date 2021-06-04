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
    collectionView.addConstarint(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
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
    iconViewModel.iconSets.first!.images.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: LocalIconSelectionViewCell.self), for: indexPath)

    if let cell = cell as? LocalIconSelectionViewCell,
       let image = UIImage.asset(EmojiIcon(rawValue: iconDetail[indexPath.row].imageName)!) {

      cell.iconView.setIcon(
        isCropped: false,
        image: image,
        bgColor: UIColor.UIColorFromString(string: iconDetail[indexPath.row].colorString))
    }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

    switch kind {

    case UICollectionView.elementKindSectionHeader:

      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: String(describing: LocalIconSelectionViewHeader.self),
        for: indexPath)

      if let header = header as? LocalIconSelectionViewHeader {
        header.subviews.first!.backgroundColor = .secondarySystemBackground
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

    onSelected?(indexPath.row, UIImage(named: moodDetail.imageName)!, UIColor.UIColorFromString(string: moodDetail.colorString))

    removeFromSuperview()
  }
}
