//
//  NibLoadable.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/23.
//

import UIKit

protocol NibLoadable: AnyObject {
  static var nib: UINib { get }
}

extension NibLoadable {

  static var nib: UINib {
    UINib(nibName: String(describing: self), bundle: Bundle(for: self))
  }
}


extension NibLoadable where Self: UIView {

  func loadNibContent() {
    guard let views = Self.nib.instantiate(withOwner: self, options: nil) as? [UIView],
          let contentView = views.first else { fatalError("Fail to load \(self) nib content") }
    self.addSubview(contentView)
    contentView.addConstarint(fill: self)
  }
}
