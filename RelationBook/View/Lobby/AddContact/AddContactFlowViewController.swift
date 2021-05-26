//
//  AddRelationViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/24.
//

import UIKit

class AddContactFlowViewController: FloatingViewController {

  @IBOutlet var iconSelectView: IconSelectView!
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

        filterView.setUp(type: .feature)

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
      }
    }
  }

  @IBOutlet var confirmButton: UIButton! {
    didSet {
      confirmButton.isEnabled = false
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

  @IBAction func onTapButton(_ sender: UIButton) {
    if sender == confirmButton {

    } else {
      self.view.removeFromSuperview()
    }
  }
}
