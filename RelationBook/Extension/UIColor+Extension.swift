//
//  UIColor+Extension.swift
//  RelationBook
//
//  Created by 曾問 on 2021/5/8.
//

import UIKit
import FlexColorPicker

extension UIColor {

  static let background = UIColor(named: "Background") ?? .systemBackground

  static let button = UIColor(named: "Button") ?? .systemGray
  static let buttonDisable = UIColor(named: "ButtonDisable")  ?? .systemGray
  static let secondaryBackground = UIColor(named: "SecondaryBackground")  ?? .secondarySystemBackground
  static let secondaryLabel = UIColor(named: "SecondaryLabel") ?? .secondaryLabel

  static let lableB1 = UIColor(named: "LabelB1") ?? .label
  static let lableB2 = UIColor(named: "LabelB2") ?? .label
  static let lableB3 = UIColor(named: "LabelB3") ?? .label
  static let lableB4 = UIColor(named: "LabelB4") ?? .label
  static let lableB5 = UIColor(named: "LabelB5") ?? .label
  static let lableB6 = UIColor(named: "LabelB6") ?? .label
  static let lableB7 = UIColor(named: "LabelB7") ?? .label
  static let lableB8 = UIColor(named: "LabelB8") ?? .label
  static let lableB9 = UIColor(named: "LabelB9") ?? .label

  static let redB1 = UIColor(named: "RedB1") ?? .systemRed
  static let redB2 = UIColor(named: "RedB2") ?? .systemRed

  static let greenB1 = UIColor(named: "GreenB1") ?? .systemGreen
  static let greenB2 = UIColor(named: "GreenB2") ?? .systemGreen

  static let categoryColor1 = UIColor(named: "Color1") ?? .clear
  static let categoryColor2 = UIColor(named: "Color2") ?? .clear
  static let categoryColor3 = UIColor(named: "Color3") ?? .clear
  static let categoryColor4 = UIColor(named: "Color4") ?? .clear
  static let categoryColor5 = UIColor(named: "Color5") ?? .clear
  static let categoryColor6 = UIColor(named: "Color6") ?? .clear
  static let categoryColor7 = UIColor(named: "Color7") ?? .clear
  static let categoryColor8 = UIColor(named: "Color8") ?? .clear
  static let categoryColor9 = UIColor(named: "Color9") ?? .clear

  func stringFromUIColor() -> String {
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
    var hColor: CGFloat = 0
    var sColor: CGFloat = 0
    var bColor: CGFloat = 0
    var aColor: CGFloat = 0
    getHue(&hColor, saturation: &sColor, brightness: &bColor, alpha: &aColor)
    return HSBColor(hue: hColor * 360, saturation: sColor, brightness: bColor)
  }
}
