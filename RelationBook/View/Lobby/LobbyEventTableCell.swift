//
//  LobbyScheduleCell.swift
//  PersonBook
//
//  Created by 曾問 on 2021/5/3.
//

import UIKit
import TagListView

class LobbyEventTableCell: UITableViewCell {

  @IBOutlet var userIcon: UIImageView!
  @IBOutlet var eventLabel: UILabel!
  @IBOutlet var moreUserView: UIView!
  @IBOutlet var tagListView: TagListView!

  var event: Event? {
    didSet {
      guard let relation = event?.getRelationImage() else { return }
      relation.getImage { self.userIcon.image = $0 }
      eventLabel.text = event?.event.title
      tagListView.addTag("qweq")
      tagListView.addTag("fghjkjik")
      tagListView.addTag("fffdaa")


      NSLayoutConstraint.activate([
        eventLabel.topAnchor.constraint(equalTo: userIcon.topAnchor, constant: 6),
        eventLabel.leadingAnchor.constraint(equalTo: userIcon.trailingAnchor, constant: 16),
        tagListView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
        tagListView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16),
        tagListView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 16),
        userIcon.topAnchor.constraint(equalTo: topAnchor),
        userIcon.bottomAnchor.constraint(equalTo: bottomAnchor),
        userIcon.heightAnchor.constraint(equalTo: userIcon.widthAnchor)
      ])
    }
  }

  override class func awakeFromNib() {
    super.awakeFromNib()
    
  }
}
