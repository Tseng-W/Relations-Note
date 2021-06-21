//
//  IconSelectionView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/3.
//

import UIKit

class IconSelectionView: UICollectionView {

  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  convenience init() {
    self.init(frame: CGRect(), collectionViewLayout: UICollectionViewFlowLayout.init())

    backgroundColor = .background
    isScrollEnabled = true

    let layout = UICollectionViewFlowLayout.init()
    layout.scrollDirection = .vertical
    layout.minimumLineSpacing = 16
    layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    layout.headerReferenceSize = CGSize(width: frame.width, height: 40)

    setCollectionViewLayout(layout, animated: true)

    lk_registerCellWithNib(identifier: String(describing: LocalIconSelectionViewCell.self), bundle: nil)
    lk_registerHeaderWithNib(identifier: String(describing: LocalIconSelectionViewHeader.self), bundle: nil)
  }
}
