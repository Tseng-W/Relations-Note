//
//  LobbyScheduleCell.swift
//  PersonBook
//
//  Created by 曾問 on 2021/5/3.
//

import UIKit
import TagListView

class LobbyEventTableCell: UITableViewCell {

  @IBOutlet var userIcon: IconView!
  @IBOutlet var eventLabel: UILabel!
  @IBOutlet var relationLabel: UILabel!
  @IBOutlet var tagListView: TagListView!

  var relations = [Relation]() {
    didSet {
      guard let event = event,
            relations.count > 0 else { return }

      relationLabel.text = "與 \(relations[0].name)"
      if relations.count > 1 {
        relationLabel.text! += " 等\(relations.count)人"
      }

      event.getRelationImage { [weak self] image in
        self?.userIcon.setIcon(
          image: image!,
          bgColor: UIColor.UIColorFromString(string: event.category.backgroundColor),
          tintColor: .clear)
      }
      eventLabel.text = event.category.title
      tagListView.addTag(event.category.title)
    }
  }

  var event: Event? {
    didSet {
      guard let event = event,
            relations.count > 0 else { return }
      event.getRelationImage { [weak self] image in
        self?.userIcon.setIcon(
          image: image!,
          bgColor: UIColor.UIColorFromString(string: event.category.backgroundColor),
          tintColor: .clear)
      }
      eventLabel.text = relations[0].name

      tagListView.addTag(event.category.title)
    }
  }

  override class func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
  }

  func setConstraint() {
    userIcon.addConstarint(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
    eventLabel.addConstarint(top: userIcon.topAnchor, left: userIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    relationLabel.addConstarint(top: userIcon.topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
    tagListView.addConstarint(top: nil, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 8, paddingRight: 16, width: 0, height: 0)
  }
}
