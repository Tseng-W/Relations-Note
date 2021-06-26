//
//  UICollectionView+Extension.swift
//  PersonBook
//
//  Created by 曾問 on 2021/5/4.
//

import UIKit

extension UICollectionView {

  func registerCellWithNib(identifier: String, bundle: Bundle?) {
    let nib = UINib(nibName: identifier, bundle: bundle)

    register(nib, forCellWithReuseIdentifier: identifier)
  }

  func registerHeaderWithNib(identifier: String, bundle: Bundle?) {
    let nib = UINib(nibName: identifier, bundle: bundle)

    register(
      nib,
      forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
      withReuseIdentifier: identifier)
  }

  func dequeueReusableCell<T: UICollectionViewCell>(cell: T.Type, indexPath: IndexPath) -> T? {
    guard let cell = dequeueReusableCell(
            withReuseIdentifier: String(describing: T.self),
            for: indexPath) as? T else {
      return nil
    }

    return cell
  }

  func rounded(
    cell: UICollectionViewCell,
    cornerRadius: CGFloat = 2,
    borderWidth: CGFloat = 1,
    shadowRadius: CGFloat = 2,
    shadowOpacity: Float = 0.5
  ) -> UICollectionViewCell {
    cell.contentView.layer.cornerRadius = cornerRadius
    cell.contentView.layer.borderWidth = borderWidth
    cell.contentView.layer.borderColor = UIColor.clear.cgColor
    cell.contentView.layer.masksToBounds = true

    cell.layer.shadowColor = UIColor.blue.cgColor
    cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
    cell.layer.shadowRadius = shadowRadius
    cell.layer.shadowOpacity = shadowOpacity
    cell.layer.masksToBounds = false
    cell.layer.shadowPath = UIBezierPath(
      roundedRect: cell.bounds,
      cornerRadius: cell.contentView.layer.cornerRadius).cgPath
    return cell
  }
}
