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
    case search = "search"
    case createNote = "createNote"
    case person = "person"
    case people = "people"
    case profile = "personalProfile"
    case talking = "talking"
    case book = "book"

    var loopMode: LottieLoopMode {
      switch self {
      case .people, .profile:
        return .autoReverse
      default:
        return .loop
      }
    }
  }

  var view: UIView {
    return UIApplication.shared.windows.first!.rootViewController!.view
  }

  var blurView: UIVisualEffectView?
  var animationView = AnimationView()

  var jobsCount: Int = 1

  func show(animation: Animation, jobs: Int = 1, isCorned: Bool = false) {
    show(view, animation: animation, jobs: jobs, useBlur: true, isCorned: isCorned)
  }

  func show(
    _ view: UIView,
    animation: Animation,
    jobs: Int = 1,
    useBlur: Bool = false,
    isCorned: Bool = false,
    multiple: CGFloat = 1,
    maxWidth: CGFloat = 0,
    maxHeight: CGFloat = 0
  ) {
    jobsCount = jobs

    if useBlur { blurView = view.addBlurView() }

    animationView = AnimationView.init(name: animation.rawValue)
    animationView.loopMode = animation.loopMode
    animationView.contentMode = .scaleAspectFit

    view.addSubview(animationView)
    animationView.addConstarint(
      centerX: view.centerXAnchor,
      centerY: view.centerYAnchor,
      width: max(maxWidth, view.frame.width * multiple),
      height: max(maxHeight, view.frame.width * multiple)
    )

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
