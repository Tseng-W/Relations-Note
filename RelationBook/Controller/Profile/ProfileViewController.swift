//
//  ProfileViewController.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

class ProfileViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.lk_registerCellWithNib(identifier: String(describing: AddFeatureTableCell.self), bundle: nil)
      tableView.lk_registerHeaderWithNib(identifier: String(describing: RelationTableHeaderCell.self), bundle: nil)
      tableView.delegate = self
      tableView.dataSource = self
    }
  }

  let headers = ["標籤設定", "個人化設定"]
  let sections = [
    ["關係類別", "事件類別", "特徵類別"],
    ["深色模式"]
  ]

  var type: CategoryType?

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    if let detailVC = segue.destination as? ProfileCategoryListView {

      guard let type = type else { return }

      detailVC.type = type
    }
  }

  override func viewDidLoad() {

    super.viewDidLoad()

    tableView.separatorColor = .clear
  }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
    headers.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    sections[section].count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: AddFeatureTableCell.self), for: indexPath)

    if let cell = cell as? AddFeatureTableCell {

      if indexPath.section == 0 {
        cell.setType(status: .edit, title: sections[indexPath.section][indexPath.row], subTitle: ">")
      } else {
        cell.setType(status: .trigger, title: sections[indexPath.section][indexPath.row], subTitle: .empty)
      }
    }

    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

    let headerView = RelationTableHeaderCell()

    headerView.tagTitleLabel.text = headers[section]

    return headerView
  }

//  func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//    false
//  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    

    if indexPath.section == 0 {
      switch indexPath.row {
      case 0:
        type = .relation
        performSegue(withIdentifier: "detail", sender: self)
      case 1:
        type = .event
        performSegue(withIdentifier: "detail", sender: self)
      case 2:
        type = .feature
        performSegue(withIdentifier: "detail", sender: self)
      default:
        break
      }
    }
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    60
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    60
  }
}
