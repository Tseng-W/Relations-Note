//
//  FilterView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import UIKit

class FilterView: UIView {

  @IBOutlet var filterViewHeightConstraint: NSLayoutConstraint!

  let eventViewModel = EventViewModel.shared
  let relationViewModel = RelationViewModel.shared
  let userViewModel = UserViewModel.shared

  var filterSource: [String] = []
  var dataSource: [Category] = []
  var selectedCategory: Category? = nil

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

    addFilterButtons()
    addCategoryCollectionViews(type: type)
  }

  private func addFilterBar() {
    filterScrollView.delegate = self
    filterScrollView.datasource = self
    filterScrollView.translatesAutoresizingMaskIntoConstraints = false
    addSubview(filterScrollView)

    NSLayoutConstraint.activate([
      filterScrollView.topAnchor.constraint(equalTo: topAnchor),
      filterScrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      filterScrollView.trailingAnchor.constraint(equalTo: trailingAnchor)
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
    //    scrollViewConstraint = NSLayoutConstraint

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
      collectionView.onSelectedSubCategory = { categories in
      }

      collectionView.onContinueEdit = {
      }

      categoryScrollView.addSubview(collectionView)
      categoryViews.append(collectionView)
      x = collectionView.frame.origin.x + viewWidth
    }
    categoryScrollView.contentSize = CGSize(width: x, height: categoryScrollView.frame.size.height)
  }

  private func addFilterButtons() {
  }

  func reloadDate() {

//    let currentPaging = filterScrollView.contentOffset.x / filterScrollView.frame.size.width

    if filterHeightConstraint?.constant == 40 {
      filterHeightConstraint?.constant = 0
      filterViewHeightConstraint.constant -= scrollHeight / 2
      categoryScrollView.isScrollEnabled = false
//      categoryViews[Int(currentPaging)].selectedCategories = [Category(id: 0, isCustom: false, superIndex: 0, title: "test", imageLink: "")]
    } else {
      filterHeightConstraint?.constant = 40
      filterViewHeightConstraint.constant += scrollHeight / 2
      categoryScrollView.isScrollEnabled = true
//      categoryViews[Int(currentPaging)].selectedCategories = []
    }

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
      self.layoutIfNeeded()
    }
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
    print(index)
  }

  func selectionView(_ selectionView: SelectionView, textColorForButtonAt index: Int) -> UIColor {
    .systemGray2
  }
}
