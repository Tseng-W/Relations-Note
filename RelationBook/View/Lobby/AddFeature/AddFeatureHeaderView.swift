//
//  AddFeatureHeaderView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/25.
//

import UIKit

class AddFeatureHeaderView: UIView, NibLoadable {

  @IBOutlet var multipleSwitch: UISwitch!

  var onTapSwitch: ((Bool) -> Void)?

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


  @IBAction func onTapSwitch(_ sender: UISwitch) {
    onTapSwitch?(sender.isOn)
  }
}
