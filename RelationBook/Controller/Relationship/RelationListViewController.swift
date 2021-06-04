//
//  RelationListViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/3.
//

import UIKit

class RelationListViewController: UIViewController {

  let userViewModel = UserViewModel()

  var superCategoryID: Int?
  var navigationTitle: String? {
    didSet {
      title = navigationTitle
    }
  }

  private var matchedRelations = [Category]() {
    didSet {
      tableView.reloadData()
    }
  }
  private var selectedIndex = -1

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.backgroundColor = .secondarySystemBackground
      tableView.rowHeight = UITableView.automaticDimension
      tableView.estimatedRowHeight = 60
      tableView.lk_registerCellWithNib(
        identifier: String(describing: RelationListTableCell.self),
        bundle: nil)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailVC = segue.destination as? RelationDetailViewController {
      if selectedIndex >= 0 && selectedIndex < matchedRelations.count {
        detailVC.relation = matchedRelations[selectedIndex]
      }
    }
  }

  override func viewDidLoad() {

    super.viewDidLoad()

    tableView.separatorColor = .clear

    guard superCategoryID != nil else { return }

    userViewModel.user.bind { [weak self] user in

      guard let index = self?.superCategoryID,
            let user = user else { return }

      self?.matchedRelations = user.getCategoriesWithSuperIndex(subType: .relation, mainIndex: index)
    }

    userViewModel.fetchUserDate()
  }
}

extension RelationListViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    matchedRelations.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(
      withIdentifier: String(describing: RelationListTableCell.self),
      for: indexPath)

    if let cell = cell as? RelationListTableCell {
       cell.relation = matchedRelations[indexPath.row]
    }

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    tableView.cellForRow(at: indexPath)?.isSelected = false
    selectedIndex = indexPath.row

    performSegue(withIdentifier: "detail", sender: nil)
  }
}
