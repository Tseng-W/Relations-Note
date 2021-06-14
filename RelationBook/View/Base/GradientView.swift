//
//  GradientView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/14.
//

import UIKit

@IBDesignable
class GradientView: UIView {

  enum Direction: Int {
    case up
    case left
    case right
    case down
  }

  @IBInspectable var directionAdapter: Int {
    get {
      return direction?.rawValue ?? Direction.up.rawValue
    }
    set(index) {
      self.direction = Direction(rawValue: index) ?? .down
    }
  }

  @IBInspectable var startColor: UIColor? {
    didSet {
      setGradient()
    }
  }

  @IBInspectable var percentage: CGFloat = 0.5 {
    didSet {
      didPercentageSettled = true
      setGradient()
    }
  }

  @IBInspectable var endColor: UIColor? {
    didSet {
      setGradient()
    }
  }

  var direction: Direction? {
    didSet {
      setGradient()
    }
  }

  private var didPercentageSettled: Bool = false

  let gradientLayer = CAGradientLayer()

  func setGradient() {

    guard let direction = direction,
          let startColor = startColor,
          let endColor = endColor,
          didPercentageSettled else { return }

    gradientLayer.frame = bounds
    gradientLayer.colors = [startColor.cgColor, endColor.cgColor]

    switch direction {
    case .up:
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
    case .left:
      gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
      gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
    case .right:
      gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
      gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
    case .down:
      gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
      gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
    }

    gradientLayer.locations = [0, NSNumber(value: Float(percentage))]

    layer.insertSublayer(gradientLayer, at: 0)
  }
}
