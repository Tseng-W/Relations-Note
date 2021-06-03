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

    // MARK: Image
    relationCategories.first!.getImage { [weak self] image in
      self?.iconImage.setIcon(
        isCropped: true,  // TODO: Replace with varible
        image: image,
        bgColor: .clear,
        tintColor: .label)
    }

    // MARK: Label
    nameLabel.text = relationCategories.first?.title
    sideBar.backgroundColor = event.getColor()

    if relationCategories.count > 1 {
      extraLabel.text = "與 \(relationCategories[1].title) 等\(relationCategories.count - 1)人"
    } else {
      extraLabel.isHidden = true
    }

    // MARK: TagView
    tagListView.removeAllTags()
    let tag = tagListView.addTag(event.category.title)
    tag.textColor = event.category.getColor()
    tag.borderColor = event.category.getColor()
  }
}
