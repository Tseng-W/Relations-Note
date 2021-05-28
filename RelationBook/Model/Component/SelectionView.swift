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

  enum ViewType {
    case stack
    case scroll
  }

  var numberOfButton: Int?
  var buttons: [UIButton] = []

  var type: ViewType = .scroll

  var indicatorView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))

  private var indicatorConstraints: [NSLayoutConstraint] = []

  weak var datasource: SelectionViewDatasource? {
    didSet {
      reloadDate()
    }
  }

  weak var delegate: SelectionViewDelegate?

  func moveIndicatorToIndex(index: Int) {

    guard index < buttons.count else { return }

    moveIndicatorView(reference: buttons[index])
  }

  func reloadDate() {
    
    subviews.forEach { $0.removeFromSuperview() }

    guard let datasource = datasource else { return }
    buttons.removeAll()


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

  private func addScrollViewContent(_ numberOfButton: Int) {

    guard let datasource = datasource else { return }

    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false

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
      NSLayoutConstraint.activate([button.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor)])
      buttons.append(button)
      lastButton = button
    }

    self.addSubview(scrollView)

    scrollView.addConstarint(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 00, paddingRight: 0, width: 0, height: 0)

    layoutIfNeeded()
    var width: CGFloat = 0
    width = scrollView.subviews.reduce(width) { sum, view in
      return sum + view.frame.width
    }
    scrollView.contentSize = CGSize(width: width, height: scrollView.frame.height)
  }

  private func addStatckViewContent(_ numberOfButton: Int) {

    guard let datasource = datasource else { return }

    let statckView = UIStackView()
    statckView.alignment = .fill
    statckView.distribution = .fillEqually
    addSubview(statckView)

    statckView.addConstarint(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)

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
    indicatorView.translatesAutoresizingMaskIntoConstraints = false
    indicatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    indicatorView.backgroundColor = datasource?.colorOfIndicator(self)

    self.addSubview(indicatorView)
    indicatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

    guard let button = self.subviews.first?.subviews[index] as? UIButton else { return }
    moveIndicatorView(reference: button, duration: 0)
  }
}

