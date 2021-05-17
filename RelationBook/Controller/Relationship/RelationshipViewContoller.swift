//
//  ViewController.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

class RelationshipViewContoller: UIViewController {

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.lk_registerCellWithNib(identifier: String(describing: RelationTableCell.self), bundle: nil)
      tableView.lk_registerHeaderWithNib(identifier: String(describing: RelationTableHeaderCell.self), bundle: nil)
    }
  }

  let relationViewModel = RelationViewModel()
  let userViewModel = UserViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    relationViewModel.fetchMockData()

    relationViewModel.relations.bind { [weak self] relations in
      self?.tableView.reloadData()
    }
  }
}

extension RelationshipViewContoller: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    var indeies: [Int] = []
    userViewModel.mockRelationCategory.forEach { category in
      if !indeies.contains(category.superIndex) {
        indeies.append(category.superIndex)
      }
    }
    return indeies.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return userViewModel.mockRelationCategory.filter({ category in
      category.superIndex == section
    }).count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RelationTableCell.self), for: indexPath)

    if let cell = cell as? RelationTableCell {
      let categories = userViewModel.mockRelationCategory.filter { $0.superIndex == indexPath.section }
      cell.tagTitleLabel.text = categories[indexPath.row].title
    }

    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: RelationTableHeaderCell.self))

    if let headerView = headerView as? RelationTableHeaderCell {
      headerView.tagTitleLabel.text = userViewModel.mockRelationFilterTitle[section]

      let tapGesture = UITapGestureRecognizer()
      tapGesture.numberOfTapsRequired = 1
      tapGesture.addTarget(headerView, action: #selector(didSelectHeaderAt(tapGesture:)))
    }

    return headerView
  }

  @objc private func didSelectHeaderAt(tapGesture: UITapGestureRecognizer) {

  }
}
