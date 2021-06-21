//
//  ProfileCategoryTableCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/7.
//

import UIKit

class ProfileCategoryTableCell: UITableViewCell {

  @IBOutlet var iconView: IconView!
  @IBOutlet var title: UILabel!

  var onEdit: ((Category) -> Void)?

  var category: Category? {
    didSet {
      guard let category = category else { return }

      category.getImage { [weak self] image in
        self?.iconView.setIcon(
          isCropped: category.isCustom,
          image: image,
          bgColor: category.getColor())

        self?.title.text = category.title
      }
    }
  }

  @IBAction func onEditTapped(_ sender: Any) {
    guard let category = category else { return }

    onEdit?(category)
  }

  @IBAction func onDeleteTapped(_ sender: UIButton) {
  }
}
