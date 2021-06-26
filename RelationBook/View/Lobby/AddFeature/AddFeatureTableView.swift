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
  var features: [Feature] = []
  var relativeCategory: [Category] = []
  let addFeatureFlowView = AddFeatureFloatView()

  weak var featureDelagate: AddFeatureTableViewDelegate? {
    didSet {
      registerCellWithNib(
        identifier: String(describing: AddFeatureTableCell.self),
        bundle: nil)

      delegate = self
      dataSource = self

      addFeatureFlowView.delegate = self
    }
  }
}

extension AddFeatureTableView: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    features.count + 1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(cell: AddFeatureTableCell.self, indexPath: indexPath) else {
      String.trackFailure("dequeueReusableCell failures")
      return AddFeatureTableCell()
    }

    if indexPath.row == features.count {
      cell.setType(status: .add)
    } else {
      let feature = features[indexPath.row]
      cell.setType(status: .edit, title: feature.name, subTitle: feature.getContentDescription())
    }

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) as? AddFeatureTableCell,
       let superview = superview {
      cell.isSelected = false

      switch cell.status {
      case .add:
        addFeatureFlowView.show(superview, category: nil, feature: nil)
      case .edit:
        let feature = features[indexPath.row]
        guard let category = relativeCategory.first(where: { $0.id == feature.categoryIndex }) else { return }

        addFeatureFlowView.show(superview, category: category, feature: feature)
      case .trigger:
        break
      }
    }
  }
}

extension AddFeatureTableView: AddFeatureFloatViewDelegate {
  func featureFloatView(view: AddFeatureFloatView, category: Category, feature: Feature) {
    features.append(feature)
    relativeCategory.append(category)

    featureDelagate?.featureTableView(tableView: self, features: features)

    reloadData()
  }
}
