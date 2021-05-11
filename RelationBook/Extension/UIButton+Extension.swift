//
//  UIButton+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/10.
//

import UIKit



@IBDesignable
extension UIButton {
    
    @IBInspectable var isCornerd: Bool {
        set {
            if newValue {
                layer.cornerRadius = frame.size.height / 2
            }
        }
        get {
            return layer.cornerRadius > 0
        }
    }
}
