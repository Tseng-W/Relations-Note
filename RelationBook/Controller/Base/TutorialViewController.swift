//
//  TutorialViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/7/8.
//

import UIKit

class TutorialViewController: UIViewController {

  var pageControl: UIPageControl = {
    let control = UIPageControl()
    control.currentPageIndicatorTintColor = .button
    control.pageIndicatorTintColor = .buttonDisable
    control.addTarget(self, action: #selector(pageControlEvent(_:)), for: .valueChanged)
    return control
  }()
  var nextButton: UIButton = {
    let button = UIButton()
    button.tag = 1
    button.cornerRadius = 8
    button.alpha = 0
    button.setTitleColor(.background, for: .normal)
    button.setTitleColor(.secondaryBackground, for: .selected)
    button.backgroundColor = .button
    button.addTarget(self, action: #selector(endTutorial(_:)), for: .touchUpInside)
    button.setTitle("紀錄美好關係", for: .normal)
    return button
  }()
  var scrollView = RBScrollView(isPagingEnabled: true)

  override func loadView() {
    super.loadView()

    view.backgroundColor = .background
    view.addSubview(pageControl)
    view.addSubview(nextButton)
    view.addSubview(scrollView)
    pageControl.tintColor = .button
    pageControl.backgroundColor = .clear
    pageControl.addConstarint(
      bottom: view.bottomAnchor,
      centerX: view.centerXAnchor,
      paddingBottom: 40,
      height: 40)
    scrollView.addConstarint(
      top: view.topAnchor,
      left: view.leftAnchor,
      bottom: pageControl.topAnchor,
      right: view.rightAnchor,
      paddingTop: 16,
      paddingLeft: 16,
      paddingBottom: 16,
      paddingRight: 16)
    nextButton.addConstarint(
      top: pageControl.topAnchor,
      left: pageControl.leftAnchor,
      bottom: pageControl.bottomAnchor,
      right: pageControl.rightAnchor
    )
    view.layoutIfNeeded()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    scrollView.delegate = self
    scrollContentInitial([.talking, .search, .createNote, .person ])
    pageControl.sizeToFit()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    pageControl.cornerRadius = pageControl.frame.height / 2
    pageControl.backgroundColor = .secondaryBackground
  }

  private func scrollContentInitial(_ tutorials: [TutorialContentView.TutorialType]) {
    var lastView: UIView?

    for type in tutorials.enumerated() {
      let nextView = TutorialContentView()
      pageControl.numberOfPages += 1

      nextView.type = type.element
      scrollView.addSubview(nextView)
      nextView.addConstarint(
        relatedBy: scrollView,
        widthMultiplier: 1,
        heightMultiplier: 1)

      if let lastView = lastView {
        nextView.addConstarint(
          top: lastView.topAnchor,
          left: lastView.rightAnchor,
          bottom: lastView.bottomAnchor)
      } else {
        nextView.addConstarint(
          top: scrollView.contentLayoutGuide.topAnchor,
          left: scrollView.contentLayoutGuide.leftAnchor,
          bottom: scrollView.contentLayoutGuide.bottomAnchor)
        lastView = nextView
        continue
      }

      lastView = nextView

      if type.offset == tutorials.count - 1 {
        nextView.addConstarint(
          right: scrollView.contentLayoutGuide.rightAnchor)
      }
    }
    scrollView.layoutIfNeeded()
  }

  @objc func endTutorial(_ sender: UIButton) {
    dismiss(animated: true)
    UserDefaults.standard.setValue("done", forKey: UserDefaults.Keys.firstLaunch.rawValue)
  }

  @objc func pageControlEvent(_ sender: UIPageControl) {
    let currentPage = sender.currentPage
    let isShowButton = currentPage == sender.numberOfPages - 1

    let point = CGPoint(x: scrollView.bounds.width * CGFloat(currentPage), y: 0)
    scrollView.setContentOffset(point, animated: true)

    nextButton.isUserInteractionEnabled = isShowButton
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: [.curveLinear]) {
      self.nextButton.alpha = isShowButton ? 1 : 0
      self.view.layoutIfNeeded()
    }
  }
}

extension TutorialViewController: UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    let paging = Int(scrollView.contentOffset.x / scrollView.frame.width)
    pageControl.currentPage = paging
    pageControlEvent(pageControl)
  }
}
