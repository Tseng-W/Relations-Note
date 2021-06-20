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

  let filterScrollView = SelectionView()
  var filterScrollHeightConstraint: NSLayoutConstraint?

  let categoryScrollView = RBScrollView(isPagingEnabled: true)
  var scrollHeight: CGFloat = 0

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
    filterScrollView.removeFromSuperview()

    filterScrollView.delegate = self
    filterScrollView.datasource = self

    addSubview(filterScrollView)

    let topConstraint = filterScrollView.topAnchor.constraint(equalTo: topAnchor)
    topConstraint.priority = .required

    filterScrollView.addConstarint(
      top: topAnchor,
      left: leftAnchor,
      right: rightAnchor,
      height: 50)
    filterScrollHeightConstraint = filterScrollView.constraints.first { $0.constant == 50 }
  }

  private func addScrollView() {
    categoryScrollView.removeFromSuperview()

    addSubview(categoryScrollView)
    categoryScrollView.addConstarint(
      top: filterScrollView.bottomAnchor,
      left: leftAnchor,
      bottom: bottomAnchor,
      right: rightAnchor)
  }

  private func addCategoryCollectionViews(type: CategoryType) {
    guard userViewModel.user.value != nil else { return }

    categoryScrollView.delegate = self
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
    filterScrollHeightConstraint?.constant = isHidden ? 0 : 40
    filterScrollView.indicatorView.isHidden = isHidden
    categoryScrollView.isScrollEnabled = !isHidden

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
      self.layoutIfNeeded()
    }
  }

  func scrollTo(main: Category, sub: Category) {
    guard categoryViews.count > main.superIndex else { return }

    didSelectedButton(filterScrollView, at: main.superIndex)

    categoryViews[main.superIndex].initialTarget = (main, sub)
  }

  func reloadDate() {
    hiddenFilterScroll(isHidden: filterScrollHeightConstraint?.constant != 0)
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

  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
      self.categoryScrollView.contentOffset.x = self.categoryScrollView.frame.width * CGFloat(index)
      self.layoutIfNeeded()
    }
  }

  func selectionView(_ selectionView: SelectionView, textColorForButtonAt index: Int) -> UIColor {
    .buttonDisable
  }

  func colorOfIndicator(_ selectionView: SelectionView) -> UIColor? {
    .buttonDisable
  }
}

extension FilterView: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let paging: CGFloat = scrollView.contentOffset.x / scrollView.frame.width
    filterScrollView.moveIndicatorToIndex(index: Int(paging))
  }
}
