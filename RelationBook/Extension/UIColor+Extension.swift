//
//  UIColor+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/8.
//

import UIKit

extension UIColor {
  
  static let background: UIColor = UIColor(named: "Background")!
  
  static let lableB1: UIColor = UIColor(named: "LabelB1")!
  
  static let lableB2: UIColor = UIColor(named: "LabelB2")!
  
  static let lableB3: UIColor = UIColor(named: "LabelB3")!
  
  static let lableB4: UIColor = UIColor(named: "LabelB4")!
  
  static let lableB5: UIColor = UIColor(named: "LabelB5")!
  
  static let lableB6: UIColor = UIColor(named: "LabelB6")!
  
  static let lableB7: UIColor = UIColor(named: "LabelB7")!
  
  static let lableB8: UIColor = UIColor(named: "LabelB8")!
  
  static let lableB9: UIColor = UIColor(named: "LabelB9")!

  func StringFromUIColor() -> String {
    guard let components = self.cgColor.components else { return "" }
    return "[\(components[0]), \(components[1]), \(components[2]), \(components[3])]"
  }

  static func UIColorFromString(string: String) -> UIColor {
    let componentsString = string.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "")
    let components = componentsString.components(separatedBy: ", ")
    return UIColor(red: CGFloat((components[0] as NSString).floatValue),
           green: CGFloat((components[1] as NSString).floatValue),
            blue: CGFloat((components[2] as NSString).floatValue),
           alpha: CGFloat((components[3] as NSString).floatValue))
  }
}
