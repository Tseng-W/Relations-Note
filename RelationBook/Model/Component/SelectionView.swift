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

  func colorOfIndicator(_ selectionView: SelectionView) -> UIColor? { return .systemGray2 }

  func initialButtonIndex(_ selectionView: SelectionView) -> Int { return 0 }

  func selectionView(_ selectionView: SelectionView, textColorForButtonAt index: Int) -> UIColor { return .systemGray2 }

  func selectionView(_ selectionView: SelectionView, fontForButtonAt index: Int) -> UIFont { return UIFont.systemFont(ofSize: 14) }
}


class SelectionView: UIView {

  var numberOfButton: Int?

  var indicatorView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

  var indicatorConstraints: [NSLayoutConstraint] = []

  weak var datasource: SelectionViewDatasource? {
    didSet {
      guard let datasource = datasource else { return }

      let numberOfButton = datasource.numberOfButton(self)
      addScrollViewContent(numberOfButton: numberOfButton)

      let index = datasource.initialButtonIndex(self)
      addIndicatorView(index: index)
    }
  }

  weak var delegate: SelectionViewDelegate?

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
    delegate.didSelectedButton(self, at: index)
  }

  private func moveIndicatorView(reference: UIButton, duration: Double = 0.3) {
    
    indicatorConstraints.forEach { $0.isActive = false }
    indicatorConstraints.removeAll()
    indicatorConstraints.append(indicatorView.widthAnchor.constraint(equalTo: reference.widthAnchor))
    indicatorConstraints.append(indicatorView.centerXAnchor.constraint(equalTo: reference.centerXAnchor))
    indicatorConstraints.forEach { $0.isActive = true }

    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: duration, delay: 0, options: .curveLinear) {
      self.layoutIfNeeded()
    }
  }

  private func addScrollViewContent(numberOfButton: Int) {

    guard let datasource = datasource else { return }

    let scrollView = UIScrollView()

    var lastButton: ResizableButton? = nil
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

      scrollView.addSubview(button)

      if let lastButton = lastButton {
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: lastButton.trailingAnchor, constant: padding)])
      } else {
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: padding)])
      }
//      NSLayoutConstraint.activate([
//        button.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//        button.topAnchor.constraint(equalTo: scrollView.topAnchor)
//      ])
      NSLayoutConstraint.activate([button.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)])

      lastButton = button
    }
    layoutIfNeeded()

    var width: CGFloat = 0
    scrollView.subviews.forEach { width += $0.frame.width }
    scrollView.contentSize = CGSize(width: width, height: scrollView.frame.height)
    layoutIfNeeded()

    self.addSubview(scrollView)

    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
  }

  private func addIndicatorView(index: Int) {
    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    indicatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    indicatorView.backgroundColor = datasource?.colorOfIndicator(self)

    self.addSubview(indicatorView)
    indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    guard let button = self.subviews.first?.subviews[index] as? UIButton else { return }
    moveIndicatorView(reference: button, duration: 0)
  }
}

