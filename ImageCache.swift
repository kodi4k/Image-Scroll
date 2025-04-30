//
//  ImageCache.swift
//  RandomPicture
//
//  Created by Ivan Alexeevich on 29.04.2025.
//

import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    static func setImage(_ image: UIImage, forKey key: String) {
        shared.setObject(image, forKey: key as NSString)
    }
    
    static func getImage(forKey key: String) -> UIImage? {
        return shared.object(forKey: key as NSString)
    }
}
