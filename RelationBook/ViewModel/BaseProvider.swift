//
//  BaseProvider.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/12.
//

import UIKit

protocol BaseProvider {
  
  func getCategories() -> [Category]
}
