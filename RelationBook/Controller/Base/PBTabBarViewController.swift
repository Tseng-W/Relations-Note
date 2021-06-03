//
//  PBTabBarViewController.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

protocol TabBarTapDelegate: AnyObject {
  func tabBarTapped(_ controller: PBTabBarViewController, index: Int)
}

private enum Tab {

  case profiles
  case relationship
  case lobby

  func controller() -> UIViewController {

    var controller: UIViewController

    switch self {

    case .profiles: controller = UIStoryboard.profile.instantiateInitialViewController()!

    case .relationship: controller = UIStoryboard.relationship.instantiateInitialViewController()!

    case .lobby: controller = UIStoryboard.lobby.instantiateInitialViewController()!

    }

    controller.tabBarItem = tabBarItem()
    controller.tabBarItem.imageInsets = UIEdgeInsets(top: 6.0, left: 0.0, bottom: -6.0, right: 0)

    return controller
  }

  func tabBarItem() -> UITabBarItem {

    switch self {

    case .profiles:
      return UITabBarItem(
        title: nil,
        image: UIImage.asset(ImageAsset.profile),
        selectedImage: UIImage.asset(ImageAsset.profile)
      )

    case .relationship:
      return UITabBarItem(
        title: nil,
        image: UIImage.asset(ImageAsset.category),
        selectedImage: UIImage.asset(ImageAsset.category)
      )

    case .lobby:
      return UITabBarItem(
        title: nil,
        image: nil,
        selectedImage: nil
      )
    }
  }

  func images() -> (icon: UIImage, add: UIImage)? {
    switch self {
    case .lobby:
      return (UIImage.asset(ImageAsset.icon)!,
              UIImage.asset(ImageAsset.pen)!)
    default:
      return nil
    }
  }
}

class PBTabBarViewController: UITabBarController {

  private var tabs: [Tab] = [.relationship, .lobby, .profiles]

  var lobbyImageButton: UIImageView = {
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
    imageView.image = Tab.lobby.images()?.add
    imageView.backgroundColor = .secondarySystemBackground
    imageView.contentMode = .scaleToFill
    imageView.isUserInteractionEnabled = true
    imageView.isCornerd = true
    return imageView
  }()

  weak var tabBarDelegate: TabBarTapDelegate?

  override func viewDidLoad() {

    super.viewDidLoad()

    lobbyButtonInit()

    viewControllers = tabs.map{ $0.controller() }

    viewControllers?.forEach { vc in
      if let navVC = vc as? UINavigationController,
         let lobbyVC = navVC.viewControllers.first as? LobbyViewController {
        tabBarDelegate = lobbyVC
      }
    }

    delegate = self

    selectedIndex = 1
  }

  private func lobbyButtonInit() {

    var center = tabBar.center
    center.y -= 40
    lobbyImageButton.center = center

    view.addSubview(lobbyImageButton)

    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(onLobbyButtonTap(tapGestureRecognizer:))
    )
    lobbyImageButton.addGestureRecognizer(tapGesture)
  }

  @objc func onLobbyButtonTap(tapGestureRecognizer: UITapGestureRecognizer) {
    guard let tappedImage   = tapGestureRecognizer.view as? UIImageView else { return }
    if tappedImage.image == Tab.lobby.images()?.add {
      tabBarDelegate?.tabBarTapped(self, index: 2)
    } else {
      tappedImage.image = Tab.lobby.images()?.add
      selectedIndex = 1
    }
  }
}

extension PBTabBarViewController: UITabBarControllerDelegate {

  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {

    let index = viewControllers?.firstIndex(of: viewController)

    return index != 1
  }

  func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    lobbyImageButton.image = Tab.lobby.images()?.icon
  }
}
