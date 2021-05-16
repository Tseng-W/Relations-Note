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

  var type: CategoryType?

  var status: Status = .mainCategory {
    didSet {
      reloadData()
    }
  }

  let userViewModel = UserViewModel()

  var selectedIndex: Int? {
    didSet {
      reloadData()
    }
  }

  var mainCategories: [Category] = [] {
    didSet {
      mainCategories.forEach { category in
        guard let type = type,
              let subCategory = userViewModel.getSubCategoriesWithSuperIndex(type: type, id: category.id) else { return }
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

  func setUp(type: CategoryType, categories: [Category]) {

    delegate = self
    dataSource = self
    backgroundColor = .background

    lk_registerCellWithNib(
      identifier: String(describing: CategoryCollectionCell.self),
      bundle: nil)

    self.type = type
    self.mainCategories = categories
  }

}

extension CategoryCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

    switch status {
    case .mainCategory:
      return mainCategories.count + 1
    case .subCategory:
      guard let index = selectedIndex else { return 0 }
      return subCategories[index].count + 1
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
          cell.titleLabel.text = "新增"
        } else {
          cell.titleLabel.text = mainCategories[indexPath.row].title
        }
      case .subCategory:
        if indexPath.row == 0 {
          cell.titleLabel.text = "返回"
        } else {
          cell.titleLabel.text = subCategories[selectedIndex!][indexPath.row - 1].title
        }
      case .selected:
        if indexPath.row == selectedCategories.count {
          cell.titleLabel.text = "新增"
        } else {
          cell.titleLabel.text = selectedCategories[indexPath.row].title
        }
      }
    }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    switch status {

    case .mainCategory:  // 主分類頁，最後按鈕為新增主分類，點其他進入子分類
      if indexPath.row < mainCategories.count {
        selectedIndex = indexPath.row
        status = .subCategory
      } else {
        // 新增
//        status = .wait
        break
      }
    case .subCategory:  // 子分類頁，第一個按鈕為返回
      if indexPath.row == 0 {
        selectedIndex = nil
        status = .mainCategory
      } else {
        guard let index = selectedIndex else { status = .mainCategory; return }
        selectedCategories = onSelectedSubCategory?(subCategories[index][indexPath.row - 1]) ?? []
      }
    case .selected:
      if indexPath.row == selectedCategories.count {
        onContinueEdit?(-1)
        status = .mainCategory
      } else {
        onContinueEdit?(indexPath.row)
        status = .mainCategory
      }
    }
  }
}
