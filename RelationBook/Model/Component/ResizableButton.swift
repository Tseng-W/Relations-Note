//
//  ResizableButton.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/15.
//

import UIKit

class ResizableButton: UIButton {

  override var intrinsicContentSize: CGSize {
    let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)) ?? .zero
    let desiredButtonSize = CGSize(
      width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right,
      height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
    return desiredButtonSize
  }
}
