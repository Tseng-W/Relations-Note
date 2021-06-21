//
//  UIStoryboard+Extension.swift
//  PersonBook
//
//  Created by 曾問 on 2021/4/30.
//

import UIKit

extension UIStoryboard {
  struct StoryboardCategory {
    static let main = "Main"

    static let login = "Login"

    static let profile = "Profile"

    static let timeline = "Timeline"

    static let relationship = "Relationship"

    static let lobby = "Lobby"
  }

  static var main: UIStoryboard { return pbStorybord(name: StoryboardCategory.main) }

  static var login: UIStoryboard { return pbStorybord(name: StoryboardCategory.login) }

  static var profile: UIStoryboard { return pbStorybord(name: StoryboardCategory.profile) }

  static var timeline: UIStoryboard { return pbStorybord(name: StoryboardCategory.timeline) }

  static var relationship: UIStoryboard { return pbStorybord(name: StoryboardCategory.relationship) }

  static var lobby: UIStoryboard { return pbStorybord(name: StoryboardCategory.lobby) }

  private static func pbStorybord(name: String) -> UIStoryboard {
    return UIStoryboard(name: name, bundle: nil)
  }
}
