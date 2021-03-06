//
//  LocalIconSelectionView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/2.
//

import UIKit

protocol LocalIconSelectionDelegate: AnyObject {

  func selectionView(selectionView: LocalIconSelectionView, didSelected image: UIImage, named: String)
}

extension LocalIconSelectionDelegate {
  func selectionView(selectionView: LocalIconSelectionView, didSelected image: UIImage, named: String) {}
}

class LocalIconSelectionView: UIViewController {
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  convenience init(type: CategoryType, hierachy: CategoryHierarchy? = nil) {
    self.init(nibName: nil, bundle: nil)

    iconViewModel = IconViewModel(type: type, hierachy: hierachy)
  }

  weak var delegate: LocalIconSelectionDelegate?

  let collectionView = IconSelectionView()

  var iconViewModel: IconViewModel? {
    didSet {
      collectionView.reloadData()
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .background

    collectionView.delegate = self
    collectionView.dataSource = self

    view.addSubview(collectionView)
    collectionView.addConstarint(fill: view)
  }
}

extension LocalIconSelectionView: UICollectionViewDelegate, UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    guard let iconViewModel = iconViewModel else { return 0 }

    return iconViewModel.iconSets.count
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    guard let iconViewModel = iconViewModel else { return 0 }

    return iconViewModel.iconSets[section].images.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(cell: LocalIconSelectionViewCell.self, indexPath: indexPath),
          let iconViewModel = iconViewModel else {
      String.trackFailure("dequeueReusableCell failures")
      return LocalIconSelectionViewCell()
    }

    if var image = iconViewModel.searchIconImage(
        set: indexPath.section,
        index: indexPath.row) {
      if indexPath.section == 0 {
        image = image.withTintColor(.label)
      }

      cell.setImage(image: image)
    }

    return cell
  }

  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:

      let header = collectionView.dequeueReusableSupplementaryView(
        ofKind: kind,
        withReuseIdentifier: String(describing: LocalIconSelectionViewHeader.self),
        for: indexPath)

      if let headerSuperView = header.subviews.first {
        headerSuperView.backgroundColor = .background
      }

      if let header = header as? LocalIconSelectionViewHeader,
         let iconViewModel = iconViewModel {
        header.titleLabel.text = iconViewModel.iconSets[indexPath.section].title
      }

      return header

    default:
      assertionFailure()
    }

    return UICollectionReusableView()
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let iconImage = iconViewModel?.searchIconImage(indexPath: indexPath)

    guard let image = iconImage else { return }

    guard let identifier = image.accessibilityIdentifier else { dismiss(animated: true); return }

    delegate?.selectionView(selectionView: self, didSelected: image, named: identifier)
    dismiss(animated: true)
  }
}
