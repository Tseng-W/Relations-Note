//
//  FilterView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import UIKit

class FilterView: UIView {

  enum Mode {
    case event
    case relation
  }

  var events = EventViewModel.shared.events.value
  var relations = RelationViewModel.shared.relations.value

  var dataSource: [Category] = []
  var currentCategory: Int?
  var selectedSubCategories: [SubCategory] = []

  var mode: Mode = .event

  let collectionView: UICollectionView = {
    let collectinoView = UICollectionView()
    collectinoView.lk_registerCellWithNib(identifier: String(describing: FilterCategoryCollectionCell.self), bundle: nil)
    collectinoView.lk_registerCellWithNib(identifier: String(describing: CategoryCollectionCell.self), bundle: nil)

    return collectinoView
  }()

  func setUp(mode: Mode) {
    self.mode = mode
    setCategoryData()
  }

  private func setCategoryData() {
    var data: [Category] = []
    switch mode {
    case .event:
      events?.forEach { event in
        data.append(event.type.category)
      }
    case .relation:
      relations?.forEach { relation in
        data.append(relation.type.category)
      }
    }

    dataSource = data
  }
}

extension FilterView: UICollectionViewDelegate, UICollectionViewDataSource {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    2
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let index = currentCategory,
          let subCategory = dataSource[index].subData else { return 0 }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    UICollectionViewCell()
  }
}
