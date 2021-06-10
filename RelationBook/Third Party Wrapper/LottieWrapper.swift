//
//  LottieWrapper.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/8.
//

import UIKit
import Lottie

class LottieWrapper: NSObject {

  static let shared = LottieWrapper()

  enum Animation: String {
    case mail = "mailSend"
    case loading = "loading"
  }

  var view: UIView {
    return UIApplication.shared.windows.first!.rootViewController!.view
  }

  var blurView: UIVisualEffectView?
  var animationView = AnimationView()

  var jobsCount: Int = 1

  func show(animation: Animation, jobs: Int = 1, isCorned: Bool = false) {
    show(view, animation: animation, jobs: jobs, isCorned: isCorned)
  }

  func show(_ view: UIView, animation: Animation, jobs: Int = 1, isCorned: Bool = false) {

    jobsCount = jobs

    blurView = view.addBlurView()

    animationView = AnimationView.init(name: animation.rawValue)

    animationView.loopMode = .loop
    animationView.contentMode = .scaleAspectFit
//    animationView.animationSpeed = 1.0

    view.addSubview(animationView)

    animationView.addConstarint(
      centerX: view.centerXAnchor, centerY: view.centerYAnchor,
      width: max(50, view.frame.width / 3),
      height: max(50, view.frame.width / 3))

    view.isCornerd = isCorned

    view.layoutIfNeeded()

    animationView.play()
  }

  func leave(jobs: Int = 1) {

    jobsCount -= 1

    if jobsCount <= 0 {
      dismiss()
    }
  }

  func dismiss() {
    blurView?.removeFromSuperview()
    animationView.removeFromSuperview()
    jobsCount = 0
  }
}
