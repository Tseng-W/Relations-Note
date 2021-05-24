//
//  AddRelationViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/24.
//

import UIKit

class AddRelationFlowViewController: FloatingViewController {

  @IBOutlet var iconSelectView: IconSelectView!
  @IBOutlet var relationButton: TitledInputView! {
    didSet {
      relationButton.titleLabel.text = "關係"
    }
  }
  @IBOutlet var featureButton: TitledInputView! {
    didSet {
      featureButton.titleLabel.text = "特徵關係"
    }
  }
  @IBOutlet var confirmButton: UIButton! {
    didSet {
      confirmButton.isEnabled = false
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    relationButton.onTapped = {
      let filterView = FilterView()
      self.view.addSubview(filterView)
      filterView.addConstarint(
        top: self.view.topAnchor,
        left: self.view.leftAnchor,
        bottom: self.view.bottomAnchor,
        right: self.view.rightAnchor,
        paddingTop: self.view.frame.height / 4,
        paddingLeft: 32,
        paddingBottom: self.view.frame.height / 4,
        paddingRight: 32, width: 0, height: 0)
      self.view.layoutIfNeeded()
      filterView.setUp(type: .relation, isMainOnly: true)

      filterView.onSelected = { categories in
        
        filterView.removeFromSuperview()
      }
    }
  }

  @IBAction func onTapButton(_ sender: UIButton) {
    if sender == confirmButton {

    } else {
      self.dismiss(animated: true)
    }
  }
}
