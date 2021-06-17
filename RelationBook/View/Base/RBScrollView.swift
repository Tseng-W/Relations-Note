//
//  RBScrollView.swift
//  RelationBook
//
//  Created by 曾問 on 2021/6/17.
//

import UIKit

class RBScrollView: UIScrollView {
  override init(frame: CGRect) {
    super.init(frame: frame)
    customSetting(isPagingEnabled: false)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  convenience init(isPagingEnabled enabled: Bool) {
    self.init(frame: CGRect())
    customSetting(isPagingEnabled: enabled)
  }

  func customSetting(isPagingEnabled: Bool) {
    self.isPagingEnabled = isPagingEnabled
    showsVerticalScrollIndicator = false
    showsHorizontalScrollIndicator = false
    alwaysBounceVertical = false
    alwaysBounceHorizontal = false
    bounces = false
    backgroundColor = .background
  }
}
