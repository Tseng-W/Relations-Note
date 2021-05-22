//
//  String+Extension.swift
//  PersonBook
//
//  Created by 曾問 on 2021/5/4.
//

import UIKit

extension String {
  
  static let empty = ""
  
  static func timestempToString(_ timestamp: Int) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp / 1000))
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
    dateFormatter.locale = NSLocale.current
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    return dateFormatter.string(from: date)
  }

  func toImage() -> UIImage? {
    if let data = Data(base64Encoded: self, options: .ignoreUnknownCharacters){
      return UIImage(data: data)
    }
    return nil
  }

  static func verifyUrl(urlString: String) -> Bool {
    if let urlString = URL(string: urlString) {
      return true
    }
    return false
  }
}
