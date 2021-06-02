//
//  testCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/2.
//

import UIKit
import TagListView


class LobbyEventCell: UITableViewCell {


  @IBOutlet var iconImage: IconView!
  @IBOutlet var sideBar: UIView! {
    didSet {
      sideBar.backgroundColor = .red
    }
  }
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var extraLabel: UILabel!
  @IBOutlet var tagListView: TagListView! {
    didSet {
      tagListView.alignment = .right
      tagListView.delegate = self
    }
  }

  var relationCategories = [Category]() {
    didSet {
      cellSetup()
    }
  }

  var event: Event? {
    didSet {
      cellSetup()
    }
  }

  func cellSetup() {

    guard let event = event,
          relationCategories.count > 0 else { return }

    extraLabel.text = "與 \(relationCategories[0].title)"
    if relationCategories.count > 1 {
      extraLabel.text! += " 等\(relationCategories.count)人"
    }

    event.getRelationImage { [weak self] image in
      self?.iconImage.setIcon(
        isCropped: true,  // TODO: Replace with varible
        image: image!,
        bgColor: .clear,
        tintColor: .label)
    }
    nameLabel.text = relationCategories.first?.title
    sideBar.backgroundColor = event.getColor()
    tagListView.removeAllTags()
    tagListView.addTag(event.category.title)
  }

}

extension LobbyEventCell: TagListViewDelegate {
  
}
