//
//  AddRelationViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/24.
//

import UIKit

class AddContactFlowViewController: FloatingViewController {

  @IBOutlet var iconSelectView: IconSelectView! {
    didSet {
      iconSelectView.onEndEditTitle = { [weak self] name, image, bgColor in
        self?.name = name
        self?.imageString = image
        self?.bgColor = bgColor
      }
    }
  }
  @IBOutlet var relationButton: TitledInputView! {
    didSet {
      relationButton.titleLabel.text = "關係"

      relationButton.onTapped = {

        let blurView = self.view.addBlurView()

        self.view.layoutIfNeeded()

        let filterView = FilterView()
        self.view.addSubview(filterView)
        filterView.addConstarint(
          top: self.view.topAnchor,
          left: self.view.leftAnchor,
          bottom: self.view.bottomAnchor,
          right: self.view.rightAnchor,
          paddingTop: self.view.frame.height / 3,
          paddingLeft: 32,
          paddingBottom: self.view.frame.height / 3,
          paddingRight: 32, width: 0, height: 0)

        self.view.layoutIfNeeded()

        filterView.setUp(type: .relation, isMainOnly: true)

        filterView.onSelected = { categories in
          self.superRelation = categories.first
          filterView.removeFromSuperview()
          blurView.removeFromSuperview()
        }
      }
    }
  }
  @IBOutlet var featureButton: TitledInputView! {
    didSet {
      featureButton.titleLabel.text = "特徵關係"

      featureButton.onTapped = {

        let blurView = self.view.addBlurView()

        let addFeatureView = AddFeatureFloatView()
        self.view.addSubview(addFeatureView)
        addFeatureView.addConstarint(
          top: self.view.topAnchor,
          left: self.view.leftAnchor,
          bottom: self.view.bottomAnchor,
          right: self.view.rightAnchor,
          paddingTop: self.view.frame.height / 4,
          paddingLeft: 32,
          paddingBottom: self.view.frame.height / 4,
          paddingRight: 32,
          width: 0, height: 0)
        
        self.view.layoutIfNeeded()

        addFeatureView.filterView.setUp(type: .feature)

        addFeatureView.onCancel = {
          blurView.removeFromSuperview()
          addFeatureView.removeFromSuperview()
        }

        addFeatureView.onConfirm = { [weak self] category, feature in
          self?.category = category
          self?.feature = feature
        }
      }
    }
  }

  @IBOutlet var confirmButton: UIButton! {
    didSet {
      confirmButton.isEnabled = false
    }
  }

  var feature: Feature? {
    didSet {
      checkContactData()
    }
  }
  var category: Category? {
    didSet {
      guard let category = category else { return }
      featureButton.placeholder = category.title
      checkContactData()
    }
  }
  var name: String? {
    didSet {
      checkContactData()
    }
  }
  var imageString: String? {
    didSet {
      checkContactData()
    }
  }
  var bgColor: UIColor? {
    didSet {
      checkContactData()
    }
  }

  var superRelation: Category? {
    didSet {
      relationButton.selectedContent = superRelation?.title
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  func checkContactData() {
    guard let _ = category,
          let _ = feature,
          let _ = name,
          let _ = imageString,
          let _ = bgColor else {
      confirmButton.isEnabled = false
      return
    }
    confirmButton.isEnabled = true
  }

  @IBAction func onTapButton(_ sender: UIButton) {
    if sender == confirmButton {
      guard let category = category,
            let feature = feature,
            let name = name,
            let image = imageString,
            let bgColor = bgColor else { return }
      RelationViewModel.shared.addRelation(name: name, iconString: image, bgColor: bgColor, relationType: category, feature: feature)
    } else {
      self.view.removeFromSuperview()
    }
  }
}
