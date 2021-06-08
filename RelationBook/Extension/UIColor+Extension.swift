//
//  UIColor+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/8.
//

import UIKit
import FlexColorPicker

extension UIColor {
  
  static let background: UIColor = UIColor(named: "Background")!

  static let button: UIColor = UIColor(named: "Button")!
  static let buttonDisable: UIColor = UIColor(named: "ButtonDisable")!
  static let secondaryBackground: UIColor = UIColor(named: "SecondaryBackground")!

  
  static let lableB1: UIColor = UIColor(named: "LabelB1")!
  
  static let lableB2: UIColor = UIColor(named: "LabelB2")!
  
  static let lableB3: UIColor = UIColor(named: "LabelB3")!
  
  static let lableB4: UIColor = UIColor(named: "LabelB4")!
  
  static let lableB5: UIColor = UIColor(named: "LabelB5")!
  
  static let lableB6: UIColor = UIColor(named: "LabelB6")!
  
  static let lableB7: UIColor = UIColor(named: "LabelB7")!
  
  static let lableB8: UIColor = UIColor(named: "LabelB8")!
  
  static let lableB9: UIColor = UIColor(named: "LabelB9")!

  static let redB1: UIColor = UIColor(named: "RedB1")!

  static let redB2: UIColor = UIColor(named: "RedB2")!

  static let greenB1: UIColor = UIColor(named: "GreenB1")!

  static let greenB2: UIColor = UIColor(named: "GreenB2")!

  static let categoryColor1: UIColor = UIColor(named: "Color1")!

  static let categoryColor2: UIColor = UIColor(named: "Color2")!

  static let categoryColor3: UIColor = UIColor(named: "Color3")!

  static let categoryColor4: UIColor = UIColor(named: "Color4")!

  static let categoryColor5: UIColor = UIColor(named: "Color5")!

  static let categoryColor6: UIColor = UIColor(named: "Color6")!

  static let categoryColor7: UIColor = UIColor(named: "Color7")!

  static let categoryColor8: UIColor = UIColor(named: "Color8")!

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

  func toUInt() -> UInt {
    var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
    if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {

      var colorAsUInt : UInt32 = 0

      colorAsUInt += UInt32(red * 255.0) << 16 +
        UInt32(green * 255.0) << 8 +
        UInt32(blue * 255.0)
      return UInt(colorAsUInt)
    }
    return UInt()
  }

  public var hsba: HSBColor {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    return HSBColor(hue: h * 360, saturation: s, brightness: b)
  }
}
