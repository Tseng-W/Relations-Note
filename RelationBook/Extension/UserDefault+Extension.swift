//
//  UserDefault+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/27.
//

import UIKit

extension UserDefaults {
  enum Keys: String {
    case style
    case uid
    case email
    case firstLaunch
  }

  func getString(key: Keys) -> String? {
    return string(forKey: key.rawValue)
  }
}
