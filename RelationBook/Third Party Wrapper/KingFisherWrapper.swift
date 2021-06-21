//
//  KingFisher+Extension.swift
//  PersonBook
//
//  Created by 曾問 on 2021/5/4.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadImage(_ urlString: String?, placeHolder: UIImage? = nil) {
      guard let urlString = urlString else { return }
        let url = URL(string: urlString)

        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}


extension UIImage {
  static func loadImage(_ urlString: String?, completion: @escaping  (UIImage?) -> Void ) {
    guard let urlString = urlString,
          let url = URL(string: urlString) else { completion(nil); return }

    let resource = ImageResource(downloadURL: url)

    KingfisherManager.shared.retrieveImage(with: resource, options: .none, progressBlock: nil) { result in
      switch result {
      case .success(let value):
        completion(value.image)
      case .failure(let error):
        print(error)
        completion(nil)
      }
    }
  }
}
