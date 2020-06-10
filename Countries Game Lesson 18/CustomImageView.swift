//
//  CustomImageView.swift
//  Countries Game
//
//  Created by Yoni on 01/06/2020.
//  Copyright © 2020 Yoni. All rights reserved.
//

import UIKit
import SVGKit

let imageCache = NSCache<NSString, UIImage>()

class CustomImageView: UIImageView {
    
    // MARK: Properties
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String, completion: @escaping (_ finish: Bool?) -> ()) {
        imageUrlString = urlString
        
        if let url = URL(string: urlString) {
            if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
                self.image = imageFromCache
                completion(true)
                return
            }
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                
                DispatchQueue.main.async {
                    let suffix = urlString.suffix(3)
                    let imageToCache = suffix == "svg" ? SVGKImage(data: data).uiImage : UIImage(data: data!)
                    
                    if self.imageUrlString == urlString {
                        self.image = imageToCache
                    }
                    
                    if imageToCache != nil {
                        imageCache.setObject(imageToCache!, forKey: urlString as NSString)
                    }
                    
                    completion(true)
                }
                
            }).resume()
        }
    }
}
