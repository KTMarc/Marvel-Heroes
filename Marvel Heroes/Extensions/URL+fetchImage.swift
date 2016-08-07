//
//  NSURL+fetchImage.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 8/8/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
import UIKit

extension URL {
    
    /// Retrieves a pre-cached image, or nil if it isn't cached.
    /// This is meant to be called before calling fetchImage.
    var cachedImage: UIImage? {
        return apiClient.sharedInstance.getCache().object(forKey: absoluteString)
    }
    
    /// Fetches the image from the network.
    /// Stores it in the cache if successful.
    /// Only calls completion on successful image download.
    /// Completion is called on the main thread.
    func fetchImage(completion: ImageCacheCompletion) {
        let task = URLSession.shared.dataTask(with:self) {
            data, response, error in
            if error == nil {
                if let  data = data,
                    let image = UIImage(data: data) {
                    apiClient.sharedInstance.getCache().setObject(
                        image,
                        forKey: self.absoluteString)
                    DispatchQueue.main.async() {
                        completion(image)
                    }
                }
            }
        }
        task.resume()
    }
    
}
