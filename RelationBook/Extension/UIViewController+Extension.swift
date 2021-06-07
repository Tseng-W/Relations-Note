//
//  UIViewController.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/7.
//

import UIKit

extension UIViewController {

  func backToRoot(completion: (() -> Void)? = nil) {

      if presentingViewController != nil {

          let superVC = presentingViewController

          dismiss(animated: false, completion: nil)

          superVC?.backToRoot(completion: completion)

          return
      }

      if let tabbarVC = self as? UITabBarController {

          tabbarVC.selectedViewController?.backToRoot(completion: completion)

          return
      }

      if let navigateVC = self as? UINavigationController {

          navigateVC.popToRootViewController(animated: false)
      }

      completion?()
  }
}
