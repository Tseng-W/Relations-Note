//
//  BookViewController.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

class BookViewController: UIViewController {

  let filterText = ["待處理", "即將到來", "已過期"]

  let userViewModel = UserViewModel()
  
  @IBOutlet var searchTextField: UITextField!

  @IBOutlet var statusSelectionView: SelectionView! {
    didSet {
      statusSelectionView.type = .stack
      statusSelectionView.delegate = self
      statusSelectionView.datasource = self
    }
  }

  @IBOutlet var filterSelectionView: SelectionView! {
    didSet {
      filterSelectionView.type = .scroll
      filterSelectionView.delegate = self
      filterSelectionView.datasource = self
    }
  }

  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self
      tableView.lk_registerCellWithNib(identifier: String(describing: BookTableCell.self), bundle: nil)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    userViewModel.fetchUserDate()
  }
}

extension BookViewController: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    80
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: BookTableCell.self), for: indexPath)
    return cell
  }
}

extension BookViewController: SelectionViewDelegate, SelectionViewDatasource {

  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
    if selectionView == statusSelectionView {

    }
  }

  func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String {
    if selectionView == statusSelectionView {
      return filterText[index]
    }
    return "Mock"
  }

  func numberOfButton(_ selectionView: SelectionView) -> Int {
    if selectionView == statusSelectionView {
      return filterText.count
    }
    return 20
  }
}
