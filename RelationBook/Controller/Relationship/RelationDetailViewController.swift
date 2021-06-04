//
//  RelationDetailViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/4.
//

import UIKit

class RelationDetailViewController: UIViewController {

  @IBOutlet var iconView: IconView! {
    didSet {
      guard let relation = relation else { return }

      relation.getImage { [weak self] image in
        self?.iconView.setIcon(
          isCropped: relation.isCustom,
          image: image,
          bgColor: relation.getColor(),
          borderWidth: 3,
          borderColor: .white,
          tintColor: .white)
      }
    }
  }
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var iconBackground: UIView!
  @IBOutlet var selectionBar: SelectionView! {
    didSet {
      selectionBar.type = .stack
      selectionBar.delegate = self
      selectionBar.datasource = self
    }
  }
  @IBOutlet var contentView: UIView!

  let relationViewModel = RelationViewModel()
  let eventViewModel = EventViewModel()

  var relation: Category? {
    didSet {
      if let iconView = iconView,
         let relation = relation {
        relation.getImage { image in
            iconView.setIcon(
            isCropped: relation.isCustom,
            image: image,
            bgColor: relation.getColor(),
            borderWidth: 3,
            borderColor: .white,
            tintColor: .white)
        }
      }
    }
  }

  override func viewDidLoad() {

    super.viewDidLoad()

    guard let relation = relation else { dismiss(animated: true); return }

    relationViewModel.fetchRelation(categoryID: relation.id) { [weak self] isSuccess in
      if !isSuccess { self?.dismiss(animated: true) }
    }
  }

  private func contentViewSetup() {
    
  }
}

extension RelationDetailViewController: SelectionViewDelegate, SelectionViewDatasource {

  func numberOfButton(_ selectionView: SelectionView) -> Int {
    2
  }

  func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String {
    let buttonTitle = ["事件", "個人資訊"]
    return buttonTitle[index]
  }

  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {

  }
}
