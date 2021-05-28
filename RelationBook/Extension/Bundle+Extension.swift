//
//  Bundle+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/19.
//

import UIKit

extension Bundle {

  static func valueForString(key: String) -> String {
    return Bundle.main.infoDictionary![key] as! String
  }
}
