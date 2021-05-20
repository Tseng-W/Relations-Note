//
//  FloatingView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/18.
//

import UIKit

class FloatingViewController: UIViewController {

  var onDismiss: (() -> Void)?

  var isVisable: Bool = false {
    didSet {
      view.layoutIfNeeded()
      UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveLinear) {
        self.view.isUserInteractionEnabled = self.isVisable
        self.view.alpha = self.isVisable ? 1 : 0
        self.view.layoutIfNeeded()
      }

      if !isVisable {
        onDismiss?()
      }
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    isVisable = false
  }

  func setBlurBackground() {

    let blurEffect = UIBlurEffect(style: .dark)
    let blurView = UIVisualEffectView(effect: blurEffect)

    blurView.frame.size = CGSize(
      width: view.frame.width,
      height: view.frame.height)
    view.insertSubview(blurView, at: 0)

    let tapGesture = UITapGestureRecognizer()
    tapGesture.numberOfTapsRequired = 1
    tapGesture.addTarget(self, action: #selector(dismissView(_:)))
    blurView.addGestureRecognizer(tapGesture)
  }

  @objc private func dismissView(_ tapGesture: UITapGestureRecognizer) {
    guard let _ = tapGesture.view as? UIVisualEffectView else { return }
    isVisable = false
  }
}
