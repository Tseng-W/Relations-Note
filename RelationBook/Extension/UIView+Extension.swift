//
//  UIView+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/11.
//

import UIKit

@IBDesignable
extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
        
        get {
            layer.cornerRadius
        }
    }
}
