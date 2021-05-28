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
  @IBOutlet var filterHeight: NSLayoutConstraint!

  @IBOutlet var confirmButton: UIButton!

  var featureViewModel = FeatureViewModel()

  var onConfirm: ((Category, Feature) -> Void)?
  var onCancel: (() -> Void)?

  var selectedCategory = [Category]()

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

    filterView.onSelected = { [weak self] categoris in
      self?.selectedCategory = categoris
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
        if let strongSelf = self {
          strongSelf.filterHeight.constant = strongSelf.filterHeight.constant / 2
          strongSelf.layoutIfNeeded()
        }
      }
    }

    filterView.onStartEdit = { [weak self] in
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
        if let strongSelf = self {
          strongSelf.filterHeight.constant = strongSelf.filterHeight.constant * 2
          strongSelf.layoutIfNeeded()
        }
      }
    }

    tableView.separatorColor = .clear

    featureViewModel.feature.bind { _ in
      self.tableView.reloadData()
    }
  }

  @IBAction func onTapCancel(_ sender: UIButton) {
    onCancel?()
  }

  @IBAction func onTapConfirm(_ sender: UIButton) {
    print(featureViewModel.feature.value)
    print(selectedCategory)
    onConfirm?(selectedCategory[0], featureViewModel.feature.value)
    onCancel?()
  }
}

extension AddFeatureFloatView: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    featureViewModel.rowNumber()
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: AddFeatureHeaderView.self))

    if let header = header as? AddFeatureHeaderView {
      header.onTapSwitch = { [weak self] isOn in
        self?.featureViewModel.canMutiSelect = isOn
      }
    }

    return header
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

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    50
  }
}
