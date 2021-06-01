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
      tableView.separatorColor = .clear
      tableView.lk_registerCellWithNib(identifier: String(describing: RelationTableCell.self), bundle: nil)
      tableView.lk_registerHeaderWithNib(identifier: String(describing: RelationTableHeaderCell.self), bundle: nil)
    }
  }

  let relationViewModel = RelationViewModel()

  override func viewDidLoad() {

    super.viewDidLoad()

    tableView.separatorColor = .clear

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
    return user.getCategoriesWithSuperIndex(mainType: .relation, filterIndex: section).count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RelationTableCell.self), for: indexPath)

    guard let user = userViewModel.user.value else { return cell }

    if let cell = cell as? RelationTableCell {
      let data = user.getCategoriesWithSuperIndex(mainType: .relation, filterIndex: indexPath.section)[indexPath.row]
      cell.tagTitleLabel.text = data.title
      cell.subLabel.isHidden = true

      data.getImage { image in
        if String.verifyUrl(urlString: data.imageLink) {
          cell.iconView.setIcon(isCropped: true, image: image, bgColor: data.getColor())
        } else {
          cell.iconView.setIcon(isCropped: false, image: image, bgColor: data.getColor())
        }
      }
    }

    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    guard let user = userViewModel.user.value else { return nil }

    let headerView = RelationTableHeaderCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))

    headerView.tag = section

    headerView.tagTitleLabel.text = "- \(user.getFilter(type: .relation)[section])"

    let tapGesture = UITapGestureRecognizer()
    tapGesture.numberOfTapsRequired = 1
    tapGesture.addTarget(headerView, action: #selector(didSelectHeaderAt(tapGesture:)))
    headerView.addGestureRecognizer(tapGesture)

    return headerView
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.cellForRow(at: indexPath)?.isSelected = false
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    50
  }

  @objc private func didSelectHeaderAt(tapGesture: UITapGestureRecognizer) {
    
  }
}
