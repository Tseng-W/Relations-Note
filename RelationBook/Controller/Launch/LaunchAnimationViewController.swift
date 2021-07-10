//
//  LaunchAnimationViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/7/10.
//

import UIKit

class LaunchAnimationViewController: UIViewController {

  @IBOutlet var iconView: UIImageView!

  var iconImageViews: [UIImageView] = []
  var iconImages: [UIImage?] = [
    UIImage.asset(ImageAsset.iconWord1),
    UIImage.asset(ImageAsset.iconWord2),
    UIImage.asset(ImageAsset.iconWord3)
  ]

  override func viewDidLoad() {
    super.viewDidLoad()

    iconImages.forEach { image in
      let imageView = UIImageView(image: image)
      imageView.alpha = 0
      view.addSubview(imageView)
      imageView.addConstarint(
        relatedBy: iconView,
        widthMultiplier: 1,
        heightMultiplier: 1
      )
      iconImageViews.append(imageView)
    }

    constraitImages()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    showWordImages()
  }

  func constraitImages() {
    iconImageViews[1].addConstarint(
      top: iconView.topAnchor,
      left: iconView.leftAnchor,
      bottom: iconView.bottomAnchor,
      right: iconView.rightAnchor)
    iconImageViews[0].addConstarint(
      top: iconView.topAnchor,
      bottom: iconView.bottomAnchor,
      right: iconView.leftAnchor,
      paddingRight: 32)
    iconImageViews[2].addConstarint(
      top: iconView.topAnchor,
      left: iconView.rightAnchor,
      bottom: iconView.bottomAnchor,
      paddingLeft: 32)
  }

  func showWordImages() {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 2, delay: 0.5, options: [.curveEaseIn]) {
      self.iconView.alpha = 0
      self.iconImageViews.forEach { $0.alpha = 1 }
      self.view.layoutIfNeeded()
    } completion: { _ in
      sleep(1)
      let controller = UIStoryboard.main.instantiateViewController(identifier: "main")
      controller.modalTransitionStyle = .crossDissolve
      controller.modalPresentationStyle = .fullScreen
      self.present(controller, animated: true)
    }
  }
}
