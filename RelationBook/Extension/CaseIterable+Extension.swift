//
//  CaseIterable+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/2.
//

import Foundation

extension CaseIterable where Self: RawRepresentable {
  static var allValues: [RawValue] {
    return allCases.map { $0.rawValue }
  }
}
