//
//  FilterContentView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/13.
//

import UIKit

protocol CategorySelectionDelegate: AnyObject {
  func initialTarget() -> (mainCategory: Category, subCategory: Category)?

  func didSelectedCategory(category: Category)

  func didStartEdit(pageIndex: Int)

  func addCategory(type: CategoryType, hierarchy: CategoryHierarchy, superIndex: Int)
}

extension CategorySelectionDelegate {
  func initialTarget() -> (mainCategory: Category, subCategory: Category)? {
    return nil
  }
}

class CategoryCollectionView: UICollectionView {
  enum Status {
    case mainCategory
    case subCategory
    case selected
  }

  // MARK: Delegate and closure
  weak var selectionDelegate: CategorySelectionDelegate?
  var onStatusChanged: ((Status) -> Void)?

  // MARK: Types
  var type: CategoryType?
  var isMainOnly: Bool = false
  var index: Int?
  var initialTarget: (main: Category, sub: Category)?


  // MARK: Status
  var status: Status = .mainCategory {
    didSet {
      reloadData()
      onStatusChanged?(status)
    }
  }
  var selectedIndex: Int? {
    didSet {
      reloadData()
    }
  }
  var selectedID: Int?

  // MARK: Datas
  var userViewModel = UserViewModel()
  var mainCategories: [Category] = [] {
    didSet {
      subCategories.removeAll()
      mainCategories.forEach { category in
        guard let type = type,
              let user = userViewModel.user.value else { return }
        var subCategory: [Category] = []
        subCategory = user.getCategoriesWithSuperIndex(subType: type, mainIndex: category.id)
        subCategories.append(subCategory)
      }
      reloadData()
    }
  }

  var subCategories: [[Category]] = []

  var selectedCategory: Category? {
    didSet {
      status = selectedCategory == nil ? .mainCategory : .selected
      reloadData()
    }
  }

  // MARK: Functions
  func setUp(index: Int, type: CategoryType, isMainOnly: Bool = false) {
    userViewModel.user.bind { [weak self] user in
      guard let user = user,
            let index = self?.index,
            let type = self?.type else { return }
      self?.mainCategories = user.getCategoriesWithSuperIndex(mainType: type, filterIndex: index)

      if let target = self?.initialTarget {
        self?.selectAt(main: target.main, sub: target.sub)
      }
    }

    userViewModel.fetchUserDate()

    delegate = self
    dataSource = self
    backgroundColor = .background

    lk_registerCellWithNib(
      identifier: String(describing: CategoryCollectionCell.self),
      bundle: nil)

    self.index = index
    self.type = type
    self.isMainOnly = isMainOnly
  }

  func selectAt(main: Category, sub: Category) {
    status = .selected
    selectedIndex = mainCategories.firstIndex { $0.id == main.id }
    selectedCategory = sub
    selectionDelegate?.didSelectedCategory(category: sub)
  }
}

extension CategoryCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    switch status {
    case .mainCategory:
      return mainCategories.count + 1
    case .subCategory:
      guard let index = selectedIndex else { return 0 }
      return subCategories[index].count + 2
    case .selected:
      return 1
    }
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = dequeueReusableCell(
      withReuseIdentifier: String(describing: CategoryCollectionCell.self),
      for: indexPath)

    if let cell = cell as? CategoryCollectionCell {
      switch status {
      case .mainCategory:
        if indexPath.row == mainCategories.count {
          cell.defaultType = .add
          return cell
        } else {
          cell.category = mainCategories[indexPath.row]
        }
      case .subCategory:
        guard let selectedIndex = selectedIndex else { return cell }
        if indexPath.row == 0 {
          cell.defaultType = .back
        } else if indexPath.row == subCategories[selectedIndex].count + 1 {
          cell.defaultType = .add
        } else {
          cell.category = subCategories[selectedIndex][indexPath.row - 1]
        }
      case .selected:
        cell.category = selectedCategory
      }
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    switch status {
    case .mainCategory:  // 主分類頁，最後按鈕為新增主 分類，點其他進入子分類
      if indexPath.row < mainCategories.count {
        if isMainOnly || !mainCategories[indexPath.row].isSubEnable {
          selectedCategory = mainCategories[indexPath.row]
          selectionDelegate?.didSelectedCategory(category: mainCategories[indexPath.row])
        } else {
          selectedIndex = indexPath.row
          selectedID = mainCategories[indexPath.row
          ].id
          status = .subCategory
        }
      } else {
        // 新增選項
        guard let superIndex = mainCategories.first?.superIndex,
              let type = type else { return }
        selectionDelegate?.addCategory(type: type, hierarchy: .main, superIndex: superIndex)
        break
      }
    case .subCategory:  // 子分類頁，第一個按鈕為返回
      guard let selectedMainIndex = selectedIndex else { status = .mainCategory; return }
      if indexPath.row == 0 {
        // 返回
        selectedIndex = nil
        status = .mainCategory
      } else if indexPath.row == subCategories[selectedMainIndex].count + 1 {
        // 新增選項
        guard let type = type,
              let id = selectedID else { return }
        selectionDelegate?.addCategory(type: type, hierarchy: .sub, superIndex: id)
      } else {
        selectedCategory = subCategories[selectedMainIndex][indexPath.row - 1]
        selectionDelegate?.didSelectedCategory(category: subCategories[selectedMainIndex][indexPath.row - 1])
      }
    case .selected:
      status = .mainCategory
      selectionDelegate?.didStartEdit(pageIndex: indexPath.row)
    }
  }

  func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    cell.alpha = 0
    layoutIfNeeded()

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.2, options: .curveLinear) {
      cell.alpha = 1
      self.layoutIfNeeded()
    }
  }
}
