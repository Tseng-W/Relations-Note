//
//  ViewController.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

class RelationshipViewContoller: UIViewController {


  let userViewModel = UserViewModel()

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.lk_registerCellWithNib(identifier: String(describing: RelationTableCell.self), bundle: nil)
      tableView.lk_registerHeaderWithNib(identifier: String(describing: RelationTableHeaderCell.self), bundle: nil)
    }
  }

  let relationViewModel = RelationViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()

    userViewModel.fetchUserDate()

    relationViewModel.relations.bind { [weak self] relations in
      self?.tableView.reloadData()
    }

    userViewModel.user.bind { [weak self] user in
      self?.tableView.reloadData()
    }
  }
}

extension RelationshipViewContoller: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    guard let user = userViewModel.user.value else { return 0 }
    return user.getFilter(type: .relation).count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let user = userViewModel.user.value else { return 0 }
    return user.getCategoriesWithSuperIndex(type: .relation, filterIndex: section).count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RelationTableCell.self), for: indexPath)

    guard let user = userViewModel.user.value else { return cell }
    

    if let cell = cell as? RelationTableCell {
      let data = user.getCategoriesWithSuperIndex(type: .relation, filterIndex: indexPath.section)[indexPath.row]
      cell.tagTitleLabel.text = data.title
      cell.tagTitleLabel.backgroundColor = data.getColor()

      data.getImage { image in
        cell.tagImgaeView.image = image
      }

    }

    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: RelationTableHeaderCell.self))

    guard let user = userViewModel.user.value else { return nil }

    if let headerView = headerView as? RelationTableHeaderCell {
      headerView.tagTitleLabel.text = user.getFilter(type: .relation)[section]

      let tapGesture = UITapGestureRecognizer()
      tapGesture.numberOfTapsRequired = 1
      tapGesture.addTarget(headerView, action: #selector(didSelectHeaderAt(tapGesture:)))
    }

    return headerView
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    50
  }

  @objc private func didSelectHeaderAt(tapGesture: UITapGestureRecognizer) {

  }
}
