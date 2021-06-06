//
//  AddFeatureFloatView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/25.
//

import UIKit

protocol AddFeatureFloatViewDelegate: AnyObject {

  func featureFloatView(view: AddFeatureFloatView, category: Category, feature: Feature)
}

class AddFeatureFloatView: UIView, NibLoadable{

  @IBOutlet var filterView: FilterView!
  @IBOutlet var tableView: UITableView! {
    didSet {
      tableView.delegate = self
      tableView.dataSource = self

      tableView.lk_registerCellWithNib(identifier: String(describing: CheckboxTableCell.self), bundle: nil)
      tableView.lk_registerHeaderWithNib(identifier: String(describing: RelationTableHeaderCell.self), bundle: nil)
    }
  }
  @IBOutlet var filterHeight: NSLayoutConstraint!
  @IBOutlet var confirmButton: UIButton!

  var featureViewModel = FeatureViewModel()

  var blurView: UIVisualEffectView?

  weak var delegate: AddFeatureFloatViewDelegate?

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
          strongSelf.filterHeight.constant = strongSelf.filterHeight.constant / 2.66
          strongSelf.layoutIfNeeded()
        }
      }
    }

    filterView.onStartEdit = { [weak self] in
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
        if let strongSelf = self {
          strongSelf.filterHeight.constant = strongSelf.filterHeight.constant * 2.66
          strongSelf.layoutIfNeeded()
        }
      }
    }

    featureViewModel.feature.bind { _ in
      self.tableView.reloadData()
    }
  }

  func show(_ view: UIView, category: Category?, feature: Feature?) {

    reset()

    tableView.separatorColor = .clear

    blurView = view.addBlurView()

    filterView.setUp(type: .feature)

    view.addSubview(self)
    addConstarint(
      left: view.leftAnchor, right: view.rightAnchor,
      centerY: view.centerYAnchor,
      paddingLeft: 16, paddingRight: 16,
      height: view.frame.height / 2)

    view.layoutIfNeeded()

    cornerRadius = frame.width * 0.05
  }

  private func reset() {

    featureViewModel.feature.value = Feature()
  }

  @IBAction func onTapCancel(_ sender: UIButton) {
    blurView?.removeFromSuperview()
    removeFromSuperview()
    onCancel?()
  }

  @IBAction func onTapConfirm(_ sender: UIButton) {

    var feature = featureViewModel.feature.value
    feature.name = selectedCategory[0].title
    feature.categoryIndex = selectedCategory[0].id

    delegate?.featureFloatView(view: self, category: selectedCategory[0], feature: feature)

    onTapCancel(sender)
  }
}

extension AddFeatureFloatView: UITableViewDelegate, UITableViewDataSource {

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    featureViewModel.amount() + 1
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = RelationTableHeaderCell(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 50))

    header.tagTitleLabel.text = "進行中"
    header.tagTitleLabel.textColor = .secondaryLabel

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
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    50
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    guard let cell = tableView.cellForRow(at: indexPath) as? CheckboxTableCell else { return }

    cell.isSelected = false
  }
}
