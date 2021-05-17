//
//  SelectEventViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/17.
//

import UIKit

class SelectEventViewController: UIViewController {


  var onSelected: ((Category) -> Void)?

  var onDismiss: (() -> Void)?

  @IBOutlet var filterView: FilterView!

  override func viewDidLoad() {
    super.viewDidLoad()

    view.layoutIfNeeded()
    filterView.setUp(type: .event)
    filterView.onSelected = { categories in
      self.onSelected?(categories.first!)
    }

    let tapGesture = UITapGestureRecognizer()
    tapGesture.numberOfTapsRequired = 1
    
  }

  @IBAction func dismissView(_ sender: UIButton) {
    onDismiss?()
  }

  @objc private func dismissSelf(_ tapGesture: UITapGestureRecognizer) {
    
  }
}
