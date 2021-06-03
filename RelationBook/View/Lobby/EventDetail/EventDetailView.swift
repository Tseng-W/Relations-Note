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

  var onDismiss: (() -> Void)?


  override init(frame: CGRect) {
    super.init(frame: frame)
    customInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    customInit()
  }

  func setUp(event: Event, relations: [Category]) {

    layoutIfNeeded()

    backgroundSet(event: event)

    if let imageLink = event.imageLink {
      UIImage.loadImage(imageLink) { [weak self] image in
        self?.eventImage.image = image
      }
    }

    event.category.getImage { [weak self] image in
      guard let image = image else { return }
      self?.categoryIconView.setIcon(isCropped: true, image: image)
    }

    let categoryBGColor = UIColor.UIColorFromString(string: event.category.backgroundColor)
    categoryIconView.setIcon(isCropped: true, bgColor: categoryBGColor, borderWidth: 3, borderColor: .white, tintColor: .white)

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


    // MARK: Mood icon set
//    let imageSet = userViewModel.moodsData.value
//    if event.mood < imageSet.count {
//      let moodData = imageSet[event.mood]
//
//      moodData.getImage { [weak self] image in
//        self?.moodImage.image = image
//      }
//      moodImage.backgroundColor = moodData.getColor()
//    }
    moodImage.isCornerd = true
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
        self?.categoryIconView.setIcon(isCropped: true, image: image, bgColor: event.getColor(), borderWidth: 4, borderColor: .white)
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
