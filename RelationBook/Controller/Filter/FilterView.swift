//
//  FilterView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import UIKit

class FilterView: UIView {
  var userViewModel = UserViewModel()

  weak var delegate: CategorySelectionDelegate?

  var onDidLayout: (() -> Void)?

  // MARK: Datas
  var filterSource: [String] = []
  var categoryViews: [CategoryCollectionView] = []
  var canScrollBeHidden = true

  var type: CategoryType? {
    didSet {
      guard let type = type,
            let user = userViewModel.user.value else { return }
      filterSource = user.getFilter(type: type)
    }
  }
  var isMainOnly: Bool = false

  let selectionView = SelectionView()
  var selectionHeightConstraint: NSLayoutConstraint?

  let categoryScrollView = RBScrollView(isPagingEnabled: true)
  var scrollHeight: CGFloat = 0

  override func layoutSubviews() {
    super.layoutSubviews()

    onDidLayout?()
  }

  func setUp(type: CategoryType, isMainOnly: Bool = false) {
    self.type = type
    self.isMainOnly = isMainOnly

    userViewModel.user.bind { [weak self] user in
      guard let user = user else { return }

      self?.filterSource = user.getFilter(type: type)

      if let categoryViews = self?.categoryViews,
         categoryViews.isEmpty {
        self?.initialFilterView()
      }
    }

    userViewModel.fetchUserDate()

    backgroundColor = .background

    scrollHeight = categoryScrollView.frame.height
  }

  private func initialFilterView() {
    layoutIfNeeded()
    addFilterBar()
    addScrollView()

    layoutIfNeeded()
    guard let type = type else { return }
    addCategoryCollectionViews(type: type)
  }

  private func addFilterBar() {
    selectionView.removeFromSuperview()

    selectionView.delegate = self
    selectionView.datasource = self

    addSubview(selectionView)

    let topConstraint = selectionView.topAnchor.constraint(equalTo: topAnchor)
    topConstraint.priority = .required

    selectionView.addConstarint(
      top: topAnchor,
      left: leftAnchor,
      right: rightAnchor,
      height: 50)
    selectionHeightConstraint = selectionView.constraints.first { $0.constant == 50 }
  }

  private func addScrollView() {
    categoryScrollView.removeFromSuperview()

    addSubview(categoryScrollView)
    categoryScrollView.addConstarint(
      top: selectionView.bottomAnchor,
      left: leftAnchor,
      bottom: bottomAnchor,
      right: rightAnchor)
  }

  private func addCategoryCollectionViews(type: CategoryType) {
    guard userViewModel.user.value != nil else { return }

    selectionView.matchedScrollView = categoryScrollView
    categoryScrollView.delegate = selectionView
    categoryScrollView.subviews.forEach { $0.removeFromSuperview() }

    let viewWidth = categoryScrollView.frame.width
    let viewHeight = categoryScrollView.frame.height
    var x: CGFloat = 0

    for index in 0..<filterSource.count {
      let collectionView = CategoryCollectionView(
        frame: CGRect(x: x, y: 0, width: viewWidth, height: viewHeight))

      collectionView.onStatusChanged = { status in
        self.hiddenFilterScroll(isHidden: status == .selected)
      }

      collectionView.setUp(index: index, type: type, isMainOnly: isMainOnly)

      categoryScrollView.addSubview(collectionView)
      categoryViews.append(collectionView)
      x = collectionView.frame.origin.x + viewWidth

      collectionView.selectionDelegate = delegate
    }

    categoryScrollView.contentSize = CGSize(width: x, height: categoryScrollView.frame.size.height)

    if let target = delegate?.initialTarget() {
      scrollTo(main: target.mainCategory, sub: target.subCategory)
    }
  }

  private func hiddenFilterScroll(isHidden: Bool) {
    guard selectionView.indicatorView.isHidden != isHidden else { return }
    selectionHeightConstraint?.constant = isHidden ? 0 : 40
    selectionView.indicatorView.isHidden = isHidden
    categoryScrollView.isScrollEnabled = !isHidden

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
      self.layoutIfNeeded()
    }
  }

  func scrollTo(main: Category, sub: Category) {
    guard categoryViews.count > main.superIndex else { return }

    selectionView.moveScrollViewToIndex(index: main.superIndex)

    categoryViews[main.superIndex].initialTarget = (main, sub)
  }

  func reloadDate() {
    hiddenFilterScroll(isHidden: selectionHeightConstraint?.constant != 0)
  }

  func reset() {
    categoryViews.forEach { $0.status = .mainCategory; $0.selectedIndex = nil }
    hiddenFilterScroll(isHidden: false)
  }
}

extension FilterView: SelectionViewDatasource, SelectionViewDelegate {
  func numberOfButton(_ selectionView: SelectionView) -> Int {
    filterSource.count
  }

  func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String {
    filterSource[index]
  }

  func selectionView(_ selectionView: SelectionView, textColorForButtonAt index: Int) -> UIColor {
    .buttonDisable
  }

  func colorOfIndicator(_ selectionView: SelectionView) -> UIColor? {
    .buttonDisable
  }
}
