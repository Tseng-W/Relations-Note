//
//  WaterfallView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/7/16.
//

import UIKit

protocol WaterfallLayoutDelegate: AnyObject {
  func columnOfWaterfall(_ collectionView: UICollectionView) -> Int
  func waterfall(_ collectionView: UICollectionView, layout waterfallLayout: WaterfallLayout, heightForItemAt indexPath: IndexPath) -> CGFloat
  func waterfall(_ collectionView: UICollectionView, layout waterfallLayout: WaterfallLayout, heightForSupplementaryView indexPath: IndexPath) -> CGFloat
}

class WaterfallLayout: UICollectionViewFlowLayout {
  weak var delegate: WaterfallLayoutDelegate?

  @IBInspectable var lineSpacing: CGFloat = 0
  @IBInspectable var columnSpacing: CGFloat = 0
  @IBInspectable var sectionTop: CGFloat = 0 {
    didSet {
      sectionInset.top = sectionTop
    }
  }
  @IBInspectable var sectionBottom: CGFloat = 0 {
    didSet {
      sectionInset.bottom = sectionBottom
    }
  }
  @IBInspectable var sectionLeft: CGFloat = 0 {
    didSet {
      sectionInset.left = sectionLeft
    }
  }
  @IBInspectable var sectionRight: CGFloat = 0 {
    didSet {
      sectionInset.right = sectionRight
    }
  }

  private var columnHeights: [Int: CGFloat] = [:]
  private var attributes: [UICollectionViewLayoutAttributes] = []

  override var collectionViewContentSize: CGSize {
    var maxHeight: CGFloat = 0
    for height in columnHeights.values where height > maxHeight {
      maxHeight = height
    }

    return CGSize.init(
      width: collectionView?.frame.width ?? 0,
      height: maxHeight + sectionInset.bottom
    )
  }

  override func prepare() {
    super.prepare()

    guard let collectionView = collectionView,
          let columnCount = delegate?.columnOfWaterfall(collectionView) else { return }

    attributes.removeAll()
    for column in 0..<columnCount {
      columnHeights[column] = sectionInset.top
    }

    let itemCount = collectionView.numberOfItems(inSection: 0)
    for row in 0..<itemCount {
      if let attribute = layoutAttributeForCell(at: IndexPath(row: row, section: 0)) {
        attributes.append(attribute)
      }
    }
  }

  private func layoutAttributeForCell(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    guard let collectionView = collectionView else { return nil }

    let attribute = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)

    let width = collectionView.frame.width
    guard let columnCount = delegate?.columnOfWaterfall(collectionView),
          columnCount > 0 else {
      return attribute
    }

    let usableWidth = width - sectionInset.left - sectionRight - (CGFloat(columnCount - 1) * columnSpacing)
    let cellWidth = usableWidth / CGFloat(columnCount)
    let cellHeight = delegate?.waterfall(
      collectionView,
      layout: self,
      heightForItemAt: indexPath) ?? 0

    var minIndex = 0
    for column in columnHeights where column.value < columnHeights[minIndex, default: 0] {
        minIndex = column.key
    }
    let cellX = sectionInset.left + (columnSpacing + cellWidth) * CGFloat(minIndex)
    let cellY = (columnHeights[minIndex] ?? 0) + lineSpacing

    attribute.frame = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
    columnHeights[minIndex] = attribute.frame.maxY
    return attribute
  }

  override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
    return true
  }

  override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributes
  }

  override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
    let attribute = UICollectionViewLayoutAttributes.init(
      forSupplementaryViewOfKind: elementKind,
      with: indexPath)
    guard let collectionView = collectionView,
          let height = delegate?.waterfall(
            collectionView,
            layout: self,
            heightForSupplementaryView: indexPath
          ) else { return attribute }
    attribute.size.height = height
    return attribute
  }
}
