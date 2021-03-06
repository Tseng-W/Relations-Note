//
//  IndicatorScrollView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/15.
//

import UIKit

protocol SelectionViewDelegate: AnyObject {
  func didSelectedButton(_ selectionView: SelectionView, at index: Int)

  func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool
}

extension SelectionViewDelegate {
  func shouldSelectedButton(_ selectionView: SelectionView, at index: Int) -> Bool { return true }

  func didSelectedButton(_ selectionView: SelectionView, at index: Int) {}
}

protocol SelectionViewDatasource: AnyObject {
  func numberOfButton(_ selectionView: SelectionView) -> Int

  func initialButtonIndex(_ selectionView: SelectionView) -> Int

  func colorOfIndicator(_ selectionView: SelectionView) -> UIColor?

  func selectionView(_ selectionView: SelectionView, titleForButtonAt index: Int) -> String

  func selectionView(_ selectionView: SelectionView, textColorForButtonAt index: Int) -> UIColor

  func selectionView(_ selectionView: SelectionView, fontForButtonAt index: Int) -> UIFont
}

extension SelectionViewDatasource {
  func numberOfButtons(in selectionView: SelectionView) -> Int { return 2 }

  func colorOfIndicator(_ selectionView: SelectionView) -> UIColor? { if #available(iOS 13.0, *) {
    return .systemGray2
  } else {
    return .color1
  } }

  func initialButtonIndex(_ selectionView: SelectionView) -> Int { return 0 }

  func selectionView(_ selectionView: SelectionView, textColorForButtonAt index: Int) -> UIColor { if #available(iOS 13.0, *) {
    return .systemGray2
  } else {
    return .color1
  } }

  func selectionView(_ selectionView: SelectionView, fontForButtonAt index: Int) -> UIFont { return UIFont.pingfang(size: 16) }
}

class SelectionView: UIView {
  enum ViewType {
    case stack
    case scroll
  }

  var numberOfButton: Int?
  var buttons: [UIButton] = []

  var type: ViewType = .scroll

  var scrollView = RBScrollView()
  var statckView = UIStackView()
  var indicatorView = UIView()

  var matchedScrollView: UIScrollView? {
    didSet {
      matchedScrollView?.delegate = self
    }
  }

  private var indicatorConstraints: [NSLayoutConstraint] = []

  weak var datasource: SelectionViewDatasource? {
    didSet {
      reloadDate()
    }
  }

  weak var delegate: SelectionViewDelegate?

  func moveScrollViewToIndex(index: Int) {
    if let scrollView = matchedScrollView {
      UIViewPropertyAnimator.runningPropertyAnimator(
        withDuration: 0.3,
        delay: 0,
        options: .curveLinear) {
        scrollView.contentOffset.x = scrollView.frame.width * CGFloat(index)
        self.layoutIfNeeded()
      }
    }
  }

  func moveIndicatorToIndex(index: Int) {
    guard index < buttons.count else { return }

    moveIndicatorView(reference: buttons[index])
  }

  func reloadDate() {
    subviews.forEach { $0.removeFromSuperview() }

    guard let datasource = datasource else { return }

    buttons.removeAll()
    scrollView.subviews.forEach { $0.removeFromSuperview() }
    statckView.subviews.forEach { $0.removeFromSuperview() }

    let numberOfButton = datasource.numberOfButton(self)

    switch type {
    case .scroll:
      addScrollViewContent(numberOfButton)
    case .stack:
      addStatckViewContent(numberOfButton)
    }

    let index = datasource.initialButtonIndex(self)

    addIndicatorView(index: index)
  }

  @objc private func shouldSelect(sender: UIButton) {
    guard let delegate = delegate,
          let index = self.subviews.first?.subviews.firstIndex(of: sender) else { return }

    let canSelect = delegate.shouldSelectedButton(self, at: index)
    if canSelect {
      didSelect(sender: sender)
    }
  }

  @objc private func didSelect(sender: UIButton) {
    guard let delegate = delegate,
          let index = self.subviews.first?.subviews.firstIndex(of: sender) else { return }
    moveIndicatorView(reference: sender)
    moveScrollViewToIndex(index: sender.tag)

    delegate.didSelectedButton(self, at: index)
  }

  private func moveIndicatorView(reference: UIButton, duration: Double = 0.3) {
    indicatorConstraints.forEach { $0.isActive = false }
    indicatorConstraints.removeAll()

    indicatorConstraints.append(indicatorView.widthAnchor.constraint(equalTo: reference.widthAnchor))
    indicatorConstraints.append(indicatorView.centerXAnchor.constraint(equalTo: reference.centerXAnchor))
    indicatorConstraints.forEach { $0.isActive = true }

    let buttonLocate = (width: reference.frame.width, originX: reference.frame.origin.x)
    let scrollLocate = (width: scrollView.frame.width, offset: scrollView.contentOffset.x)
    var targetOffsetX = scrollView.contentOffset.x

    if scrollLocate.width > 0 {
      if scrollLocate.offset > buttonLocate.originX {
        targetOffsetX = buttonLocate.originX
      } else if abs(buttonLocate.originX + buttonLocate.width - scrollLocate.offset) > scrollLocate.width {
        targetOffsetX = buttonLocate.originX - scrollLocate.width + buttonLocate.width
      }
    }

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveLinear) {
      self.scrollView.contentOffset.x = targetOffsetX
      self.layoutIfNeeded()
    }
  }

  private func addScrollViewContent(_ numberOfButton: Int) {
    guard let datasource = datasource else { return }

    var lastButton: ResizableButton?
    let padding: CGFloat = 16

    for index in 0..<numberOfButton {
      let title = datasource.selectionView(self, titleForButtonAt: index)
      let textColor = datasource.selectionView(self, textColorForButtonAt: index)

      let button = ResizableButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.tag = index
      button.setTitle(title, for: .normal)
      button.setTitleColor(textColor, for: .normal)
      button.addTarget(self, action: #selector(shouldSelect(sender:)), for: .touchUpInside)
      button.titleLabel?.font = UIFont.pingfang(size: 16)

      scrollView.addSubview(button)

      if let lastButton = lastButton {
        NSLayoutConstraint.activate(
          [button.leadingAnchor.constraint(equalTo: lastButton.trailingAnchor, constant: padding)]
        )
      } else {
        NSLayoutConstraint.activate(
          [button.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: padding)]
        )
      }
      NSLayoutConstraint.activate([button.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)])
      buttons.append(button)
      lastButton = button
    }

    self.addSubview(scrollView)
    scrollView.addConstarint(fill: self)

    layoutIfNeeded()
    var width: CGFloat = 0
    width = scrollView.subviews.reduce(width) { sum, view in
      return sum + view.frame.width + padding
    }
    scrollView.contentSize = CGSize(width: width, height: scrollView.frame.height)
  }

  private func addStatckViewContent(_ numberOfButton: Int) {
    guard let datasource = datasource else { return }

    statckView = UIStackView()
    statckView.alignment = .fill
    statckView.distribution = .fillEqually

    addSubview(statckView)
    statckView.addConstarint(fill: self)

    for index in 0..<numberOfButton {
      let title = datasource.selectionView(self, titleForButtonAt: index)
      let textColor = datasource.selectionView(self, textColorForButtonAt: index)
      let button = ResizableButton()

      button.translatesAutoresizingMaskIntoConstraints = false
      button.tag = index
      button.setTitle(title, for: .normal)
      button.setTitleColor(textColor, for: .normal)
      button.addTarget(self, action: #selector(shouldSelect(sender:)), for: .touchUpInside)

      buttons.append(button)

      statckView.addArrangedSubview(button)
    }
  }

  private func addIndicatorView(index: Int) {
    indicatorView.removeFromSuperview()
    indicatorView.constraints.forEach { $0.isActive = false }

    indicatorView.translatesAutoresizingMaskIntoConstraints = false

    indicatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

    indicatorView.backgroundColor = datasource?.colorOfIndicator(self)

    self.addSubview(indicatorView)
    indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    guard let contentView = self.subviews.first,
          index < contentView.subviews.count,
          let button = contentView.subviews[index] as? UIButton else { return }
    moveIndicatorView(reference: button, duration: 0)
  }
}

extension SelectionView: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let paging: CGFloat = scrollView.contentOffset.x / scrollView.frame.width
    moveIndicatorToIndex(index: Int(paging))
  }
}
