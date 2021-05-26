//
//  AddFeatureFloatView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/25.
//

import UIKit

class AddFeatureFloatView: UIView, NibLoadable{

  @IBOutlet var filterView: FilterView!
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self

      tableView.lk_registerCellWithNib(identifier: String(describing: CheckboxTableCell.self), bundle: nil)
      tableView.lk_registerHeaderWithNib(identifier: String(describing: AddFeatureHeaderView.self), bundle: nil)
    }
  }

  @IBOutlet var confirmButton: UIButton!


  var featureViewModel = FeatureViewModel()

  var onConfirm: (([(isSelected: Bool, content: String)]) -> Void)?
  var onCancel: (() -> Void)?

  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  convenience init() {
    self.init(frame: CGRect())
    customInit()
  }

  override class func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
  }

  func customInit() {
    loadNibContent()

    featureViewModel.feature.bind { _ in
      self.tableView.reloadData()
    }
  }

  @IBAction func onTapCancel(_ sender: UIButton) {
    onCancel?()
  }

  @IBAction func onTapConfirm(_ sender: UIButton) {
  }
}

extension AddFeatureFloatView: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    featureViewModel.rowNumber()
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CheckboxTableCell.self), for: indexPath)

    if let cell = cell as? CheckboxTableCell {

      cell.setup(content: featureViewModel.cellForRowAt(row: indexPath.row))

      cell.onEndEdit = { [weak self] cell, content in
        guard let index = self?.tableView.indexPath(for: cell)?.row else { return }
        self?.featureViewModel.editCellContent(index: index, content: content)
      }

      cell.onSwitchPrecessing = { [weak self] cell in
        guard let indexPath = self?.tableView.indexPath(for: cell) else { return }
        self?.featureViewModel.selectedSwitchAt(row: indexPath.row)
      }
    }

    return cell
  }
}
