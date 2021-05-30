//
//  FilterContentView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/13.
//

import UIKit

class CategoryCollectionView: UICollectionView {

  enum Status {
    case mainCategory
    case subCategory
    case selected
  }

  var onSelectedSubCategory: ((Category?) -> [Category])?

  var onContinueEdit: ((Int) -> Void)?

  var onAddCategory: ((CategoryType, CategoryHierarchy, Int) -> Void)?

  var type: CategoryType?
  var isMainOnly: Bool = false

  var status: Status = .mainCategory {
    didSet {
      reloadData()
    }
  }

  var userViewModel = UserViewModel()
  var index: Int?

  var selectedIndex: Int? {
    didSet {
      reloadData()
    }
  }

  var mainCategories: [Category] = [] {
    didSet {
      subCategories.removeAll()
      mainCategories.forEach { category in
        guard let type = type,
              let user = userViewModel.user.value else { return }
        var subCategory: [Category] = []
        switch type {
        case .event:
          subCategory = user.eventSet.getSubCategories(superIndex: category.id)
        case .feature:
          subCategory = user.featureSet.getSubCategories(superIndex: category.id)
        case .relation:
          subCategory = user.relationSet.getSubCategories(superIndex: category.id)
        }
        subCategories.append(subCategory)
      }
      reloadData()
    }
  }

  var subCategories: [[Category]] = []

  var selectedCategories: [Category] = [] {
    didSet {
      status = selectedCategories.count > 0 ? .selected : .mainCategory
      reloadData()
    }
  }

  func setUp(index: Int, type: CategoryType, isMainOnly: Bool = false) {

    userViewModel.user.bind { [weak self] user in
      guard let user = user,
            let index = self?.index,
            let type = self?.type else { return }
      self?.mainCategories = user.getCategoriesWithSuperIndex(type: type, filterIndex: index)
    }

    userViewModel.fetchUserDate()

    delegate = self
    dataSource = self
    backgroundColor = .secondarySystemBackground

    lk_registerCellWithNib(
      identifier: String(describing: CategoryCollectionCell.self),
      bundle: nil)

    self.index = index
    self.type = type
    self.isMainOnly = isMainOnly
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
      return selectedCategories.count + 1
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
        if indexPath.row == 0 {
          cell.defaultType = .back
        } else if indexPath.row == subCategories[selectedIndex!].count + 1 {
          cell.defaultType = .add
        } else {
          cell.category = subCategories[selectedIndex!][indexPath.row - 1]
        }
      case .selected:
        if indexPath.row == selectedCategories.count {
          cell.defaultType = .add
        } else {
          cell.category = selectedCategories[indexPath.row]
        }
      }
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    switch status {

    case .mainCategory:  // 主分類頁，最後按鈕為新增主 分類，點其他進入子分類
      if indexPath.row < mainCategories.count {
        if isMainOnly || !mainCategories[indexPath.row].isSubEnable {
          selectedCategories = onSelectedSubCategory?(mainCategories[indexPath.row]) ?? []
        } else {
          selectedIndex = indexPath.row
          status = .subCategory
        }
      } else {
        // 新增選項
        guard let superIndex = mainCategories.first?.superIndex,
              let type = type else { return }
        onAddCategory?(type, .main, superIndex)
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
        guard let type = type else { return }
        onAddCategory?(type, .sub, selectedMainIndex)
      } else {
        selectedCategories = onSelectedSubCategory?(subCategories[selectedMainIndex][indexPath.row - 1]) ?? []
      }
    case .selected:
      if indexPath.row == selectedCategories.count {
        // 新增項目
        onContinueEdit?(-1)
        status = .mainCategory
      } else {
        // 修改
        onContinueEdit?(indexPath.row)
        status = .mainCategory
      }
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
