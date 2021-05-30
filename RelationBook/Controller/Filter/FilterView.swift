//
//  FilterView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import UIKit

class FilterView: UIView {

  var userViewModel = UserViewModel()

  // MARK: Event closures
  var onSelected: (([Category]) -> Void)?
  var onStartEdit: (() -> Void)?
  var onAddCategory: ((CategoryType, CategoryHierarchy, Int) -> Void)?

  // MARK: Datas
  var filterSource: [String] = []
  var selectedCategories: [Category] = []
  var isEditing = false

  var filterIndex: Int = 0
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
  var filterHeightConstraint: NSLayoutConstraint?

  let categoryScrollView: UIScrollView = {

    let scrollView = UIScrollView()
    scrollView.isPagingEnabled = true
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.alwaysBounceVertical = false
    scrollView.alwaysBounceHorizontal = false
    return scrollView
  }()
  var scrollHeight: CGFloat = 0

  func setUp(type: CategoryType, isMainOnly: Bool = false) {

    self.type = type
    self.isMainOnly = isMainOnly

    userViewModel.user.bind { [weak self] user in
      guard let user = user else { return }
      self?.filterSource = user.getFilter(type: type)
      self?.initialFilterView()
    }

    userViewModel.fetchUserDate()

    backgroundColor = .secondarySystemBackground

    filterIndex = 0

    scrollHeight = categoryScrollView.frame.height
  }

  private func initialFilterView() {
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

    filterScrollView.addConstarint(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
    filterHeightConstraint = filterScrollView.constraints.first(where: { $0.constant == 50 })
  }

  private func addScrollView() {
    categoryScrollView.removeFromSuperview()

    addSubview(categoryScrollView)
    categoryScrollView.addConstarint(top: filterScrollView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
  }

  private func addCategoryCollectionViews(type: CategoryType) {

    guard let user = userViewModel.user.value else { return }

    categoryScrollView.delegate = self
    categoryScrollView.subviews.forEach { $0.removeFromSuperview() }

    let viewWidth = categoryScrollView.frame.width
    let viewHeight = categoryScrollView.frame.height
    var x: CGFloat = 0

    for index in 0..<filterSource.count {

      let layout = UICollectionViewFlowLayout()
      layout.itemSize = CGSize(width: 60, height: 70)

      let collectionView = CategoryCollectionView(frame: CGRect(x: x, y: 0, width: viewWidth, height: viewHeight), collectionViewLayout: layout)
      
      collectionView.setUp(index: index, type: type, isMainOnly: isMainOnly)

      categoryScrollView.addSubview(collectionView)
      categoryViews.append(collectionView)
      x = collectionView.frame.origin.x + viewWidth

      collectionView.onSelectedSubCategory = { [weak self] category in
        if let category = category {
          self?.selectedCategories.append(category)
          self?.onSelected?(self?.selectedCategories ?? [])
        }

        if let strongSelf = self {
          if strongSelf.canScrollBeHidden {
            strongSelf.onHiddenFilter(isHidden: true)
          }
        }
        
        return self?.selectedCategories ?? []
      }

      collectionView.onContinueEdit = { [weak self] index in
        self?.isEditing = index == -1
        self?.onHiddenFilter(isHidden: false)
        self?.onStartEdit?()
      }

      collectionView.onAddCategory = { [weak self] type, hierarchy, superIndex in
        self?.onAddCategory?(type, hierarchy, superIndex)
      }
    }
    categoryScrollView.contentSize = CGSize(width: x, height: categoryScrollView.frame.size.height)
  }

  private func onHiddenFilter(isHidden: Bool) {

    filterHeightConstraint?.constant = isHidden ? 0 : 40
    filterScrollView.indicatorView.isHidden = isHidden

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
      self.categoryScrollView.isScrollEnabled = !isHidden
      self.layoutIfNeeded()
    }
  }

  func reloadDate() {
    onHiddenFilter(isHidden: filterHeightConstraint?.constant != 0)
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
    .systemGray2
  }
}

extension FilterView: UIScrollViewDelegate {

  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let paging: CGFloat = scrollView.contentOffset.x / scrollView.frame.width
    filterScrollView.moveIndicatorToIndex(index: Int(paging))
  }
}
