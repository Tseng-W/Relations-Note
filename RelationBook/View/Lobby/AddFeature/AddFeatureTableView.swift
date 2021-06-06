//
//  AddFeatureTableView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/5.
//

import UIKit

protocol AddFeatureTableViewDelegate: AnyObject {

  func featureTableView(tableView: AddFeatureTableView, features: [Feature])
}

class AddFeatureTableView: UITableView {

  var features = [Feature]()

  weak var featureDelagate: AddFeatureTableViewDelegate? {
    didSet {
      lk_registerCellWithNib(
        identifier: String(describing: AddFeatureTableCell.self),
        bundle: nil)

      delegate = self
      dataSource = self
    }
  }

}

extension AddFeatureTableView: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    features.count + 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: String(describing: AddFeatureTableCell.self),
      for: indexPath)

    if let cell = cell as? AddFeatureTableCell {
      if indexPath.row == features.count - 1 {
        cell.setType(status: .add)
      } else {
        cell.setType(status: .edit, title: "t", subTitle: "s")
      }
    }

    return cell
  }
}
