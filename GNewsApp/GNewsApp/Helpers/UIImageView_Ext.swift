//
//  UIImageView_Ext.swift
//  GNewsApp
//
//  Created by vladikkk on 29/11/2021.
//

import UIKit
import RxSwift

extension UIImage {
    func load(url: URL) -> Single<UIImage?> {
        return URLSession.shared.rx
            .data(request: URLRequest(url: url))
                .map { data in UIImage(data: data) }
                .asSingle()
                .catchAndReturn(nil)
    }
}



// Cache images
//let imageCache = NSCache<NSString, UIImage>()
//
//extension UIImageView {
//    func loadImage(withUrl url: URL) {
//        if let cachedImage = imageCache.object(forKey: NSString(string: url.absoluteString)) {
//            self.image = cachedImage
//            return
//        }
//
//        DispatchQueue.global().async { [weak self] in
//            if let imageData = try? Data(contentsOf: url) {
//                if let image = UIImage(data: imageData) {
//                    DispatchQueue.main.async {
//                        imageCache.setObject(image, forKey: NSString(string: url.absoluteString))
//
//                        self?.image = image
//                    }
//                }
//            }
//        }
//    }
//}

