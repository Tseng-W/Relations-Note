//
//  Array+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/6.
//

import UIKit

extension Array {

  public func toDictionary<Key: Hashable>(with selectKey: (Element) -> Key) -> [Key: Element] {
    var dict: [Key: Element] = [:]
    for element in self {
      dict[selectKey(element)] = element
    }
    return dict
  }
}
