//
//  RelationTableHeaderCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/17.
//

import UIKit

class RelationTableHeaderCell: UIView, NibLoadable {

  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  func customInit() {
    loadNibContent()
  }

  @IBOutlet var tagTitleLabel: UILabel!

  @IBOutlet var subInfoLabel: UILabel!

  override class func awakeFromNib() {
    super.awakeFromNib()
  }
}
