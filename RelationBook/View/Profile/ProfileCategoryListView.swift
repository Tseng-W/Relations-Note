//
//  ProfileCategoryListView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/7.
//

import UIKit

class ProfileCategoryListView: UIViewController {

  var type: CategoryType?

  var userViewModel = UserViewModel()
  var eventViewModel = EventViewModel()
  var relationViewModel = RelationViewModel()

  let setCategoryStyleView = SetCategoryStyleView()
  var editingCategory: Category?

  @IBOutlet var selectionView: SelectionView! {
    didSet {
      selectionView.delegate = self
      selectionView.datasource = self
    }
  }

  @IBOutlet var scrollView: UIScrollView! {
    didSet {
      scrollView.alwaysBounceHorizontal = false
      scrollView.alwaysBounceVertical = false
      scrollView.bouncesZoom = false
      scrollView.isPagingEnabled = true
      scrollView.showsVerticalScrollIndicator = false
      scrollView.showsHorizontalScrollIndicator = false

      scrollView.delegate = selectionView
    }
  }

  var categories: [Category] = [] {
    didSet {
      scrollView.subviews.forEach { view in
        if let view = view as? UITableView {
          view.reloadData()
        }
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard type != nil else { navigationController?.popViewController(animated: false); return }

    setCategoryStyleView.delegate = self
    selectionView.matchedScrollView = scrollView

    userViewModel.user.bind { [weak self] user in
      guard let user = user,
            let type = self?.type else { return }

      if self?.scrollView.subviews.isEmpty ?? false {
        self?.scrollViewInitial()
      }

      self?.categories = user.getCategoriesWithSuperIndex(mainType: type)

      self?.selectionView.reloadDate()
    }

    eventViewModel.events.bind { [weak self] _ in
      self?.scrollView.subviews.forEach { view in
        guard let view = view as? UITableView else { return }
        view.reloadData()
      }
    }

    relationViewModel.relations.bind { [weak self] _ in
      self?.scrollView.subviews.forEach { view in
        guard let view = view as? UITableView else { return }
        view.reloadData()
      }
    }

    userViewModel.fetchUserDate()
    eventViewModel.fetchEvents()
    relationViewModel.fetchRelations()
  }

  private func scrollViewInitial() {
    guard let user = userViewModel.user.value,
          let type = type else { return }

    var pageCount = 0
    let pagePadding: CGFloat = 16.0
    var x: CGFloat = 0

    scrollView.subviews.forEach { $0.removeFromSuperview() }

    pageCount = user.getFilter(type: type).count

    for index in 0..<pageCount {
      let tableView = UITableView()
      tableView.delegate = self
      tableView.dataSource = self
      tableView.tag = index
      tableView.separatorColor = .clear
      tableView.backgroundColor = .background
      tableView.registerCellWithNib(
        identifier: String(describing: ProfileCategoryTableCell.self),
        bundle: nil)

      scrollView.addSubview(tableView)

      tableView.frame.origin = CGPoint(x: x, y: pagePadding / 2.0)
      tableView.frame.size = CGSize(
        width: scrollView.frame.width - pagePadding / 2.0,
        height: scrollView.frame.height)

      scrollView.contentSize.width += scrollView.frame.width
      x += scrollView.frame.width
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(true)

    //    backToRoot()
  }
}

// MARK: - Selection View Delegate
extension ProfileCategoryListView: SelectionViewDelegate, SelectionViewDatasource, UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    if scrollView != self.scrollView { return }

    let paging = scrollView.contentOffset.x / scrollView.frame.width

    selectionView.moveIndicatorToIndex(index: Int(paging))
  }
  func numberOfButton(_ selectionView: SelectionView) -> Int {
    guard let user = userViewModel.user.value else { return 0 }

    switch type {
    case .event:
      return user.getFilter(type: .event).count
    case .feature:
      return user.getFilter(type: .feature).count
    case .relation:
      return user.getFilter(type: .relation).count
    default:
      return 0
    }
  }

  func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String {
    guard let user = userViewModel.user.value else { return .empty }

    switch type {
    case .event:
      return user.getFilter(type: .event)[index]
    case .feature:
      return user.getFilter(type: .feature)[index]
    case .relation:
      return user.getFilter(type: .relation)[index]
    default:
      return .empty
    }
  }

  func colorOfIndicator(_ selectionView: SelectionView) -> UIColor? {
    .buttonDisable
  }

  func selectionView(_ selectionView: SelectionView, textColorForButtonAt index: Int) -> UIColor {
    .buttonDisable
  }
}

// MARK: - Table View Delegate ( For Categories )
extension ProfileCategoryListView: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    categories.filter { $0.superIndex == tableView.tag }.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    1
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(cell: ProfileCategoryTableCell.self, indexPath: indexPath),
          let type = type else {
      String.trackFailure("dequeueReusableCell failures")
      return ProfileCategoryTableCell()
    }

    cell.category = categories.filter { $0.superIndex == tableView.tag } [indexPath.section]
    cell.onEdit = { category in
      self.editingCategory = category

      self.setCategoryStyleView.show(
        self.view,
        type: type,
        hierarchy: .main,
        superIndex: category.superIndex,
        submitWhenConfirm: true
      )
    }

    return cell
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = UIView()

    header.backgroundColor = .clear

    return header
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    16
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    50
  }
}

extension ProfileCategoryListView: CategoryStyleViewDelegate {
  func categoryStyleView(
    styleView: SetCategoryStyleView,
    isCropped: Bool,
    name: String,
    backgroundColor: UIColor,
    image: UIImage,
    imageString: String
  ) {
    guard userViewModel.user.value != nil,
          var category = editingCategory,
          let type = type else { return }

    category.isCustom = isCropped
    category.title = name
    category.backgroundColor = backgroundColor.stringFromUIColor()
    category.imageLink = imageString

    FirebaseManager.shared.updateUserCategory(
      type: type,
      hierarchy: .main,
      category: &category)
  }
}
