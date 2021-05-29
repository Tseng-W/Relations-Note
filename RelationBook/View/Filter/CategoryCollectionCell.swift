//
//  CategoryCollectionCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {

  enum DefaultType {
    case add
    case back
  }

  @IBOutlet var iconImageView: UIImageView!

  @IBOutlet var titleLabel: UILabel!

  var defaultType: DefaultType? {
    didSet {
      switch defaultType {
      case .add:
        category = Category(id: 0, isCustom: false, superIndex: -1, isSubEnable: true, title: "新增", imageLink: "plus", backgroundColor: UIColor.systemGray2.StringFromUIColor())
      case .back:
        category = Category(id: 0, isCustom: false, superIndex: -1, isSubEnable: true, title: "返回", imageLink: "arrowshape.turn.up.left", backgroundColor: UIColor.systemGray2.StringFromUIColor())
      default:
        break
      }
    }
  }

  var category: Category? {
    didSet {
      guard let category = category else { return }

      category.getImage { image in
        guard let image = image else { return }
        self.iconImageView.image = image
      }

      titleLabel.text = category.title
      iconImageView.tintColor = category.getColor()
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }
}
