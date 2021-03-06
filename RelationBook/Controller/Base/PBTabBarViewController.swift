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
      if let icon = UIImage.asset(ImageAsset.icon),
         let add = UIImage.assetSystem(SysetmAsset.add) {
        return (icon, add)
      } else {
        return nil
      }
    default:
      return nil
    }
  }
}

class PBTabBarViewController: UITabBarController {
  private var tabs: [Tab] = [.relationship, .lobby, .profiles]

  var iconImageButton: IconView = {
    let iconView = IconView(frame: CGRect(x: 0, y: 0, width: 70, height: 70))

    iconView.accessibilityIdentifier = "addEventButton"

    iconView.setIcon(
      isCropped: false,
      image: Tab.lobby.images()?.add,
      bgColor: .background,
      borderWidth: 3,
      borderColor: .button,
      tintColor: .buttonDisable,
      multiple: 0.8)
    iconView.isUserInteractionEnabled = true

    return iconView
  }()

  weak var tabBarDelegate: TabBarTapDelegate?

  override func viewDidLoad() {
    super.viewDidLoad()

    lobbyButtonInit()

    tabBar.tintColor = .button
    tabBar.barTintColor = .secondaryBackground
    tabBar.unselectedItemTintColor = .buttonDisable

    viewControllers = tabs.map { $0.controller() }

    viewControllers?.forEach { viewController in
      if let navVC = viewController as? UINavigationController,
         let lobbyVC = navVC.viewControllers.first as? LobbyViewController {
        tabBarDelegate = lobbyVC
      }
    }

    delegate = self

    selectedIndex = 1
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(true)
    if UserDefaults.standard.getString(key: .firstLaunch) == nil {
      let tutorialViewController = TutorialViewController()
      tutorialViewController.isModalInPresentation = true
      present(tutorialViewController, animated: true)
    }
  }

  private func lobbyButtonInit() {
    var center = tabBar.center
    center.y -= iconImageButton.frame.height / 2
    iconImageButton.center = center

    view.addSubview(iconImageButton)

    let tapGesture = UITapGestureRecognizer(
      target: self,
      action: #selector(onLobbyButtonTap(tapGestureRecognizer:))
    )

    iconImageButton.addGestureRecognizer(tapGesture)
  }

  @objc func onLobbyButtonTap(tapGestureRecognizer: UITapGestureRecognizer) {
    guard let tappedImage = tapGestureRecognizer.view as? IconView else { return }

    if selectedIndex == 1 {
      tabBarDelegate?.tabBarTapped(self, index: 2)
    } else {
      tappedImage.setIcon(isCropped: false, image: Tab.lobby.images()?.add, borderWidth: 3, tintColor: .buttonDisable)
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
    iconImageButton.setIcon(isCropped: true, image: Tab.lobby.images()?.icon, borderWidth: 0, multiple: 0.8)
  }
}
