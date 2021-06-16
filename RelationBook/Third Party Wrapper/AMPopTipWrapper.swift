//
//  AMPopTipWrapper.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/12.
//

import UIKit
import AMPopTip

class PopTipManager: NSObject {

  enum Attribute {
    case backgroundColor(_: UIColor)
    case tintColor(_: UIColor)
    case textColor(_: UIColor)
    case bubbleColor(_: UIColor)
    case bubbleOffset(_: CGFloat)
    case shadowColor(_: UIColor)
    case shadowOffset(_: CGSize)

    case animateBounce(_: CGFloat)
    case animateFloat(x: CGFloat, y:CGFloat)
    case animatePulse(_: CGFloat?)
  }

  struct PopTarget {

    var target: UIView
    var text: String?
    var customView: UIView?
    var direction: PopTipDirection
    var duration: TimeInterval?
    var attributes: [Attribute]

    func showPopTip() -> PopTip {

      var popTip = PopTip()

      popTip.shouldDismissOnTap = true
      popTip.shouldDismissOnTapOutside = true

      popTip = setAttribute(popTip: popTip)

      guard let originRect = target.globalFrame else { return popTip }

      if let text = text {
        popTip.show(text: text,
                    direction: direction,
                    maxWidth: 200,
                    in: UIView.rootView,
                    from: originRect,
                    duration: duration)
      } else if let view = customView {
        popTip.show(customView: view,
                    direction: direction,
                    in: UIView.rootView,
                    from: originRect,
                    duration: duration)
      }
      return popTip
    }

    private func setAttribute(popTip: PopTip) -> PopTip {
      attributes.forEach { attribute in
        switch attribute {
        case let .animateFloat(x: x, y: y):
          popTip.actionAnimation = .float(offsetX: x, offsetY: y)
        case let .animatePulse(float):
          popTip.actionAnimation = .pulse(float)
        case let .animateBounce(float):
          popTip.actionAnimation = .bounce(float)
        case let .backgroundColor(color):
          popTip.backgroundColor = color
        case let .bubbleColor(color):
          popTip.bubbleColor = color
        case let .bubbleOffset(offset):
          popTip.bubbleOffset = offset
        case let .shadowColor(color):
          popTip.shadowColor = color
        case let .shadowOffset(size):
          popTip.shadowOffset = size
        case let .textColor(color):
          popTip.textColor = color
        case let .tintColor(color):
          popTip.tintColor = color
        }
      }

      return popTip
    }
  }

  struct Style {
    static let defaultStyle: [Attribute] = [.bubbleColor(.button), .textColor(.background)]
    static let alertStyle: [Attribute] = [.bubbleColor(.categoryColor9), .textColor(.background)]
  }

  static let shared = PopTipManager()

  private var popTargets = [PopTarget]()

  private var blurView = UIView()

  var view = UIView.rootView

  func show(isBlur: Bool = true) {
    if isBlur {
      addBlurView()
    }
    showNext()
  }

  func addPopTip(at target: UIView, text: String, direction: PopTipDirection, duration: TimeInterval? = nil, attributes: [Attribute]? = nil) -> PopTipManager {

    let popData = PopTarget(target: target, text: text, customView: nil, direction: direction, duration: duration, attributes: attributes ?? PopTipManager.Style.defaultStyle)

    popTargets.append(popData)

    return PopTipManager.shared
  }

  private func showNext() {

    if let next = popTargets.first {

      popTargets.removeFirst()
      let popTip = next.showPopTip()

      popTip.dismissHandler = { [weak self] popTip in
        //        popTip.hide()
        self?.showNext()
      }
    } else {
      dismiss()
    }
  }

  private func addBlurView() {

    let shared = PopTipManager.shared

    blurView.backgroundColor = .systemBackground
    blurView.alpha = 0.3

    UIView.rootView.addSubview(blurView)
    blurView.addConstarint(
      top: shared.view.topAnchor,
      left: shared.view.leftAnchor,
      bottom: shared.view.bottomAnchor,
      right: shared.view.rightAnchor)
  }

  @objc func dismiss() {

    if !Thread.isMainThread {

      DispatchQueue.main.async {
        PopTipManager.shared.dismiss()
      }
      return
    }

    blurView.removeFromSuperview()
    popTargets.removeAll()
  }
}
