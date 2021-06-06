//
//  testCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/2.
//

import UIKit
import TagListView


class LobbyEventCell: UITableViewCell {

  enum CellType {
    case lobby
    case relation
  }

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


  var event: Event?
  var relations = [Category]()

  func cellSetup(type: CellType, event: Event, relations: [Category]) {

    guard let relation = relations.first else { return }

    self.event = event
    self.relations = relations

    switch type {
    case .lobby:
      if relations.count > 1 {
        extraLabel.text = "與 \(relations[1].title) 等\(relations.count - 1)人"
      } else {
        extraLabel.isHidden = true
      }

    case .relation:
      extraLabel.text = event.time.dateValue().getDayString(type: .time)
    }

    // MARK: Label
    nameLabel.text = relation.title
    sideBar.backgroundColor = event.getColor()

    // MARK: Image
    relation.getImage { [weak self] image in
      self?.iconImage.setIcon(
        isCropped: relation.isCustom,
        image: image,
        bgColor: .clear,
        tintColor: .label)
    }


    // MARK: TagView
    tagListView.removeAllTags()
    let tag = tagListView.addTag(event.category.title)
    tag.textColor = event.category.getColor()
    tag.borderColor = event.category.getColor()
  }
}
