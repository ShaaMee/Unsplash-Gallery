//
//  ImageService.swift
//  Unsplash Gallery
//
//  Created by user on 23.11.2021.
//

import UIKit

class ImageService {
    
    static let shared = ImageService()
    
    // Using image caching
    private var imageCache = NSCache<NSString, UIImage>()
    
    func image(forURLString urlString: String, completion: @escaping (UIImage?, String?) -> () ){
        
        // If there is a cached image then passing it to closure and returning nil dataTask
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            completion(cachedImage, nil)
            
        } else {
            // Fetching image from server and saving it to cache
            guard let url = URL(string: urlString) else { return }
            
            NetworkService.shared.fetchDataFromURL(url) { [weak self] (data, errorText) in
                guard let image = UIImage(data: data) else { return }
                self?.imageCache.setObject(image, forKey: urlString as NSString)
                completion(image, errorText)
            }
        }
    }
}
