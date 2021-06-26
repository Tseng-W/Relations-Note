//
//  UITableView+Extension.swift
//  PersonBook
//
//  Created by 曾問 on 2021/5/4.
//

import UIKit

extension UITableView {
  func registerCellWithNib(identifier: String, bundle: Bundle?) {
    let nib = UINib(nibName: identifier, bundle: bundle)

    register(nib, forCellReuseIdentifier: identifier)
  }

  func registerHeaderWithNib(identifier: String, bundle: Bundle?) {
    let nib = UINib(nibName: identifier, bundle: bundle)

    register(nib, forHeaderFooterViewReuseIdentifier: identifier)
  }

  func dequeueReusableCell<T: UITableViewCell>(cell: T.Type, indexPath: IndexPath) -> T? {
    guard let cell = dequeueReusableCell(
            withIdentifier: String(describing: T.self),
            for: indexPath) as? T else {
      return nil
    }

    return cell
  }
}

extension UITableViewCell {
  static var identifier: String {
    return String(describing: self)
  }
}

extension UITableViewHeaderFooterView {
  static var identifier: String {
    return String(describing: self)
  }
}
