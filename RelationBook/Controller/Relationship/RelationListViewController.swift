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

  private var matchedRelations: [Category] = [] {
    didSet {
      tableView.reloadData()
    }
  }
  private var selectedIndex = -1

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.backgroundColor = .background
      tableView.rowHeight = UITableView.automaticDimension
      tableView.estimatedRowHeight = 60
      tableView.registerCellWithNib(
        identifier: String(describing: RelationListTableCell.self),
        bundle: nil)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailVC = segue.destination as? RelationDetailViewController {
      if selectedIndex >= 0 && selectedIndex < matchedRelations.count {
        detailVC.relationCategory = matchedRelations[selectedIndex]
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
  func numberOfSections(in tableView: UITableView) -> Int {
    if matchedRelations.isEmpty {
      tableView.addPlaceholder(
        image: UIImage.getPlaceholder(
          .friend,
          style: traitCollection.userInterfaceStyle),
        description: "沒有符合的對象")
      return 0
    } else {
      tableView.removePlaceholder()
      return 1
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return matchedRelations.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(cell: RelationListTableCell.self, indexPath: indexPath) else {
      String.trackFailure("dequeueReusableCell failures")
      return RelationListTableCell()
    }

    cell.relation = matchedRelations[indexPath.row]

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.isSelected = false
    selectedIndex = indexPath.row

    performSegue(withIdentifier: "detail", sender: nil)
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }
}
