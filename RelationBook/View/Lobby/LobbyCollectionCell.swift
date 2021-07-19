//
//  LobbyCollectionCell.swift
//  RelationBook
//
//  Created by 曾問 on 2021/7/16.
//

import UIKit

class LobbyCollectionCell: UICollectionViewCell {

  @IBOutlet var backgroundImageView: UIImageView!
  @IBOutlet var relationIconView: IconView!
  @IBOutlet var commentLabel: UILabel!
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var moodBarView: UIView!

  var event: Event? {
    didSet {
      guard let event = event else { return }
      setEvent(event)
    }
  }
  var category: Category? {
    didSet {
      guard let category = category else { return }
      setCategory(category)
    }
  }

  func setEvent(_ event: Event) {
    if let imageLink = event.imageLink {
      DispatchQueue.global().async {
        UIImage.loadImage(imageLink) { [weak self] image in
          DispatchQueue.main.async {
            self?.backgroundImageView.image = image
          }
        }
      }
    } else {
      backgroundImageView.backgroundColor = event.getColor()
    }

    moodBarView.backgroundColor = UIColor.UIColorFromString(string: UserViewModel.moodData[event.mood].colorString)
  }

  func setCategory(_ category: Category) {
    category.getImage { [weak self] image in
      DispatchQueue.main.async {
        self?.relationIconView.setIcon(
          isCropped: category.isCustom,
          image: image,
          bgColor: category.getColor()
        )
        self?.setNeedsLayout()
      }
    }
  }

  func setUp(relation: Category, event: Event) {
    contentView.translatesAutoresizingMaskIntoConstraints = true

    nameLabel.text = relation.title

    self.category = relation
    self.event = event

    commentLabel.text = event.comment
    timeLabel.text = event.time.dateValue().getDayString(type: .time)
    cornerRadius = 16

    backgroundColor = .clear

    layer.masksToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 1, height: 1)
    layer.shadowRadius = 5
    layer.shadowOpacity = 0.5

    contentView.backgroundColor = .secondaryBackground
    contentView.layer.cornerRadius = 16
  }

  override func prepareForReuse() {
//    super.prepareForReuse()


  }
}
