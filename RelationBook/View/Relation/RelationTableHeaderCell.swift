//
//  RelationTableHeaderCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/17.
//

import UIKit

@IBDesignable
class RelationTableHeaderCell: UIView, NibLoadable {

  @IBInspectable var title: String = .empty {
    didSet {
      tagTitleLabel.text = title
    }
  }

  @IBInspectable var subTitle: String = .empty {
    didSet {
      subInfoLabel.text = subTitle
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  private func customInit() {
    loadNibContent()
  }

  @IBOutlet var tagTitleLabel: UILabel!

  @IBOutlet var subInfoLabel: UILabel!

  @IBOutlet var tipsButton: UIButton!

  var tips: (() -> Void)? {
    didSet {
      guard tips != nil else { return }

      tipsButton.isHidden = false
    }
  }

  @IBAction func onTappedTipsButton(_ sender: UIButton) {
    tips?()
  }

  override class func awakeFromNib() {
    super.awakeFromNib()
  }
}
