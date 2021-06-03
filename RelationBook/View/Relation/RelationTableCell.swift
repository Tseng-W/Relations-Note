//
//  RelationTableCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/17.
//

import UIKit

class RelationTableCell: UITableViewCell {

  @IBOutlet var iconView: IconView!
  
  @IBOutlet var tagTitleLabel: UILabel!
  
  @IBOutlet var subLabel: UILabel!

  var subRelations = [Category]() {
    didSet {
      update()
    }
  }

  var category: Category? {
    didSet {
      update()
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {

    alpha = 0

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .curveLinear) {
      self.alpha = 1
      self.layoutIfNeeded()
    }

    update()
  }

  func update() {
    guard let category = category else { return }
    category.getImage { [weak self] image in
      guard let image = image else { return }
      self?.iconView.setIcon(
        isCropped: category.isCustom,
        image: image,
        bgColor: category.getColor(),
        tintColor: .white)
    }

    tagTitleLabel.text = "\(category.title) (\(subRelations.count) 人)"
    subLabel.isHidden = true
  }
}
