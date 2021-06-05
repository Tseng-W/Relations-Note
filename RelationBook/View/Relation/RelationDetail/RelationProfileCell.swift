//
//  RelationProfileCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/5.
//

import UIKit

class RelationProfileCell: UITableViewCell {

  @IBOutlet var featureLabel: UILabel!

  var feature = Feature()

  func setup(feature: Feature, index: Int) {
    self.feature = feature
    featureLabel.text = "\(feature.name) : \(feature.contents[index].content)"
  }
}
