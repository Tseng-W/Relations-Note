//
//  EventDetailView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/31.
//

import UIKit

class EventDetailView: UIView, NibLoadable {

  let userViewModel = UserViewModel()

  @IBOutlet var eventImage: UIImageView!
  @IBOutlet var eventBackground: UIView!
  @IBOutlet var categoryIconView: IconView!
  @IBOutlet var relationIconView: IconView!
  @IBOutlet var moodImage: UIImageView!
  @IBOutlet var relationName: UILabel!
  @IBOutlet var locaionLabel: UILabel!
  @IBOutlet var timeLabel: UILabel!
  @IBOutlet var commentTextView: UITextView!

  var onDismiss: (() -> Void)?

  var event: Event?
  var relations = [Category]()

  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  func setUp(event: Event, relations: [Category]) {

    self.event = event
    self.relations = relations

    layoutIfNeeded()

    cornerRadius = 16

    backgroundSet(event: event)

    if let imageLink = event.imageLink {
      UIImage.loadImage(imageLink) { [weak self] image in
        self?.eventImage.image = image
      }
    }

    event.category.getImage { [weak self] image in
      guard let image = image else { return }
      self?.categoryIconView.setIcon(isCropped: true, image: image, multiple: 0.5)
    }

    let categoryBGColor = UIColor.UIColorFromString(string: event.category.backgroundColor)
    categoryIconView.setIcon(isCropped: true, bgColor: categoryBGColor, borderWidth: 3, borderColor: .white, tintColor: .white, multiple: 0.5)

    // MARK: Relation data set
    let mainRelation = relations.first!

    mainRelation.getImage { [weak self] image in
      guard let image = image else { return }
      self?.relationIconView.setIcon(isCropped: true, image: image)
    }

    relationIconView.setIcon(isCropped: true, bgColor: mainRelation.getColor(), borderWidth: 2, borderColor: .white, tintColor: .white)

    relationName.text = mainRelation.title
    if let geoPoint = event.location {
      locaionLabel.text = "\(geoPoint.longitude.rounded()), \(geoPoint.latitude.rounded())"
    } else {
      locaionLabel.text = "-"

    }

    timeLabel.text = event.time.dateValue().getDayString(type: .time)

    let moodData = UserViewModel.moodData[event.mood]

    if let image = UIImage(named: moodData.imageName) {
      moodImage.image = image
      moodImage.backgroundColor = UIColor.UIColorFromString(string: moodData.colorString)
    }

    moodImage.isCornerd = true

    commentTextView.text = event.comment
  }

  func backgroundSet(event: Event) {

    if let eventImageLink = event.imageLink {
      UIImage.loadImage(eventImageLink) { [weak self] image in
        self?.eventImage.image = image
      }
      categoryIconView.isHidden = true

    } else {
      eventImage.isHidden = true
      eventBackground.backgroundColor = event.getColor()
      event.category.getImage {  [weak self] image in
        self?.categoryIconView.setIcon(isCropped: true, image: image, bgColor: event.getColor(), borderWidth: 4, borderColor: .white, multiple: 0.5)
      }
    }
  }

  func customInit() {
    loadNibContent()
  }

  @IBAction func onTapDismiss(_ sender: UIButton) {
    removeFromSuperview()
    onDismiss?()
  }
}
