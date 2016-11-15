//
//  NSURL+fetchImage.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 8/8/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
import UIKit

/**
 Retrieves a pre-cached image, or downloads it if it isn't cached.
 We use the URL as a key to save the image in the cache and be able to retrieve afterwards.
 */

extension URL {
    
    /**
     Returns the image using it's URL as key
     It is meant to be called before calling fetchImage.
     returns: UIImage or Nil if we don't have the image in the cache
     */

    var cachedImage: UIImage? {
        return apiClient.manager.getCache().object(forKey: absoluteString as NSString)
    }
    
    /**
     Fetches the image from the network and stores it in the cache if successful.
     Only calls completion on the main thread on successful image download.
     */
    
    func fetchImage(completion: @escaping ImageCacheCompletion) {
        let task = URLSession.shared.dataTask(with:self) {
            data, response, error in
            if error == nil {
                if let  dataa = data,
                    let image = UIImage(data: dataa) {
                    apiClient.manager.getCache().setObject(
                        image,
                        forKey: self.absoluteString as NSString)
                    DispatchQueue.main.async() {
                        completion(image)
                    }
                }
            }
        }
        task.resume()
    }
    
}
