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

  override func layoutSubviews() {
    super.layoutSubviews()

    
  }

  var event: Event?
  var relations = [Category]()

  func cellSetup(type: CellType, event: Event, relations: [Category]) {

    guard let relation = relations.first else { return }

    let moodData = UserViewModel.moodData

    self.event = event
    self.relations = relations

    switch type {

    case .lobby:

      if relations.count > 1 {
        extraLabel.text = "與 \(relations[1].title) 等\(relations.count - 1)人"
      } else {
        extraLabel.isHidden = true
      }

      nameLabel.text = relation.title

      relation.getImage { [weak self] image in
        self?.iconImage.setIcon(
          isCropped: relation.isCustom,
          image: image,
          bgColor: .clear,
          tintColor: .label,
          multiple: 1)
      }

    case .relation:

      nameLabel.text = event.category.title
      extraLabel.text = event.time.dateValue().getDayString(type: .time)

      layoutIfNeeded()
      event.category.getImage { [weak self] image in
        self?.iconImage.setIcon(
          isCropped: event.category.isCustom,
          image: image,
          bgColor: event.category.getColor()
          )
      }
    }

    sideBar.backgroundColor = UIColor.UIColorFromString(string: moodData[event.mood].colorString)

    // MARK: TagView
    tagListView.removeAllTags()
    let tag = tagListView.addTag(event.category.title)
    tag.textColor = event.category.getColor()
    tag.borderColor = event.category.getColor()
  }
}
