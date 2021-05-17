//
//  FilterView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import UIKit

class FilterView: UIView {

  @IBOutlet var filterViewHeightConstraint: NSLayoutConstraint!

  let eventViewModel = EventViewModel()
  let relationViewModel = RelationViewModel()
  let userViewModel = UserViewModel()

  var onSelected: (([Category]) -> Void)?

  var filterSource: [String] = []
  var selectedCategories: [Category] = []
  var isEditing = false

  var filterIndex: Int = 0
  var categoryViews: [CategoryCollectionView] = []

  var type: CategoryType? {
    didSet {
      guard let type = type else { return }
      filterSource = userViewModel.getFilter(type: type)
    }
  }

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

  func setUp(type: CategoryType) {

    self.type = type
    filterIndex = 0

    addFilterBar()
    addScrollView()
    layoutIfNeeded()

    scrollHeight = categoryScrollView.frame.height

    addCategoryCollectionViews(type: type)
  }

  private func addFilterBar() {
    filterScrollView.delegate = self
    filterScrollView.datasource = self
    filterScrollView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(filterScrollView)

    let topConstraint = filterScrollView.topAnchor.constraint(equalTo: topAnchor)
    topConstraint.priority = .required

    NSLayoutConstraint.activate([
      topConstraint,
      filterScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      filterScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])


    filterHeightConstraint = NSLayoutConstraint(item: filterScrollView,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 1,
                                                constant: 50)
    filterHeightConstraint?.isActive = true
  }

  private func addScrollView() {

    addSubview(categoryScrollView)
    NSLayoutConstraint.activate([
      categoryScrollView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
      categoryScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      categoryScrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      categoryScrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  private func addCategoryCollectionViews(type: CategoryType) {

    let viewWidth = categoryScrollView.frame.width
    let viewHeight = categoryScrollView.frame.height
    var x: CGFloat = 0

    for index in 0..<filterSource.count {
      let categoryData = userViewModel.getCategoriesWithSuperIndex(type: type, index: index)

      let layout = UICollectionViewFlowLayout()
      layout.itemSize = CGSize(width: 60, height: 70)

      let collectionView = CategoryCollectionView(frame: CGRect(x: x, y: 0, width: viewWidth, height: viewHeight), collectionViewLayout: layout)
      collectionView.setUp(type: type, categories: categoryData)
      collectionView.onSelectedSubCategory = { category in
        if let category = category {
          self.selectedCategories.append(category)
          self.onSelected?(self.selectedCategories)
        }

        self.onHiddenFilter(isHidden: true)
        return self.selectedCategories
      }

      collectionView.onContinueEdit = { index in
        self.isEditing = index == -1
        self.onHiddenFilter(isHidden: false)
      }

      categoryScrollView.addSubview(collectionView)
      categoryViews.append(collectionView)
      x = collectionView.frame.origin.x + viewWidth
    }
    categoryScrollView.contentSize = CGSize(width: x, height: categoryScrollView.frame.size.height)
  }

  private func onHiddenFilter(isHidden: Bool) {

      filterHeightConstraint?.constant = isHidden ? 0 : 40
      filterScrollView.indicatorView.isHidden = isHidden
//      self.filterViewHeightConstraint.constant -= self.scrollHeight / 2 // 向上通知縮小
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
