//
//  RelationListTableCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/3.
//

import UIKit

class RelationListTableCell: UITableViewCell {

  @IBOutlet private var sideBarView: UIView!

  @IBOutlet private var iconView: IconView!

  @IBOutlet private var relationNameLabel: UILabel!

  var relation: Category? {
    didSet {
      guard let relation = relation else { return }
      sideBarView.backgroundColor = relation.getColor()

      relation.getImage { [weak self] image in
        self?.iconView.setIcon(
          isCropped: false,
          image: image,
          bgColor: .clear)
      }

      relationNameLabel.text = relation.title
    }
  }
}
