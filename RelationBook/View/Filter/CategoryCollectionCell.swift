//
//  CategoryCollectionCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {


  @IBOutlet var iconImageView: UIImageView!

  @IBOutlet var titleLabel: UILabel!

  var icon: Icon?

  override func awakeFromNib() {

    super.awakeFromNib()
  }
}
