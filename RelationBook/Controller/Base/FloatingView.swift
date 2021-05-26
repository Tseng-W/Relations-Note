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

      onVisibleChanged(isVisible: isVisable)
      if !isVisable {
        onDismiss?()
      }
    }
  }

  var blurView: UIVisualEffectView?

  override func viewDidLoad() {
    super.viewDidLoad()
    isVisable = false
  }

  func onVisibleChanged(isVisible: Bool) {

  }

  func setBlurBackground() {

    let blurEffect = UIBlurEffect(style: .dark)
    blurView = UIVisualEffectView(effect: blurEffect)

    blurView!.frame.size = CGSize(
      width: view.frame.width,
      height: view.frame.height)
    view.insertSubview(blurView!, at: 0)

    let tapGesture = UITapGestureRecognizer()
    tapGesture.numberOfTapsRequired = 3
    tapGesture.addTarget(self, action: #selector(dismissView(_:)))
    tapGesture.delegate = self
//    blurView!.addGestureRecognizer(tapGesture)
  }

  @objc private func dismissView(_ tapGesture: UITapGestureRecognizer) {
    guard tapGesture.view == blurView else { return }
    isVisable = false
  }
}

extension FloatingViewController: UIGestureRecognizerDelegate {

  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {

    if touch.view?.isDescendant(of: view.subviews[1]) == true {
      return false
    }
    return true
  }
}
