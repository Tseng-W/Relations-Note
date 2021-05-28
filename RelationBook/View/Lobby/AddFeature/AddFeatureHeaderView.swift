//
//  AddFeatureHeaderView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/25.
//

import UIKit

class AddFeatureHeaderView: UITableViewHeaderFooterView {

  @IBOutlet var multipleSwitch: UISwitch!

  var onTapSwitch: ((Bool) -> Void)?

  @IBAction func onTapSwitch(_ sender: UISwitch) {
    onTapSwitch?(sender.isOn)
  }
}
