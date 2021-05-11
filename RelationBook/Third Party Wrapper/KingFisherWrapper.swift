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

        guard urlString != nil else { return }
        
        let url = URL(string: urlString!)

        self.kf.setImage(with: url, placeholder: placeHolder)
    }
}
