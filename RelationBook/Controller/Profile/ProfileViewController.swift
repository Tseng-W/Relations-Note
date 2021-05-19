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
      tableView.lk_registerCellWithNib(identifier: String(describing: ProfileTableViewCell.self), bundle: nil)
      tableView.lk_registerHeaderWithNib(identifier: String(describing: ProfileHeaderViewCell.self), bundle: nil)
      tableView.delegate = self
      tableView.dataSource = self
    }
  }

  let headers = ["個人資料", "帳戶綁定", "個人化設定", "更多"]
  let sections = [
    ["個人數據"],
    ["Facebook", "Line", "Twitter", "LinkedIn"],
    ["文字大小", "深色模式"],
    ["推播通知"]
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {

  func numberOfSections(in tableView: UITableView) -> Int {
//    headers.count
    0
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    sections[section].count
    0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileTableViewCell.self), for: indexPath)

//    if let cell = cell as? ProfileTableViewCell {
//      cell.titleLabel.text = sections[indexPath.section][indexPath.row]
//    }

    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: ProfileHeaderViewCell.self))

//    if let header = headerView as? ProfileHeaderViewCell {
//      header.titleLabel.text = headers[section]
//    }

    return headerView
  }
}
