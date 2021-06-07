//
//  LottieWrapper.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/8.
//

import UIKit
import Lottie

class LottieWrapper: NSObject {

  enum Animation: String {
    case mail = "mailSend"
    case loading = "loading"
  }

  var blurView: UIVisualEffectView?
  var animationView = AnimationView()

  var jobsCount: Int = 1

  func show(_ view: UIView, animation: Animation, jobs: Int = 1) {

    jobsCount = jobs

    blurView = view.addBlurView()

    animationView = AnimationView.init(name: animation.rawValue)

    animationView.loopMode = .loop
    animationView.contentMode = .scaleAspectFit
//    animationView.animationSpeed = 1.0

    view.addSubview(animationView)

    animationView.addConstarint(
      centerX: view.centerXAnchor, centerY: view.centerYAnchor,
      width: 150, height: 150)

    animationView.play()
  }

  func leave(jobs: Int = 1) {
    jobsCount -= 1


    if jobsCount == 0 {
      dismiss()
    }
  }

  func dismiss() {
    blurView?.removeFromSuperview()
    animationView.removeFromSuperview()
    jobsCount = 0
  }
}
