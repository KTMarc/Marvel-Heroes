//
//  UIImageView+AsyncDownload.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 2/8/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit


/* SWIFT 3 version here
 http://stackoverflow.com/questions/24231680/loading-downloading-image-from-url-on-swift
 */
extension UIImageView {
    func downloadAsyncFrom(_ link: String, contentMode mode: UIViewContentMode, completion: (() -> ())? = nil) {
        guard let url = URL(string: link) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse , httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType , mimeType.hasPrefix("image"),
                let data = data , error == nil,
                let image = UIImage(data: data)
                else { return }
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.image = image
                self.contentMode = mode
                completion?()
            })
        }
        task.resume()
    }
}

/*
 Make it better adding cache and detection of visible cells on the screen
 http://sweettutos.com/2015/12/31/swift-how-to-asynchronously-download-and-cache-images-without-relying-on-third-party-libraries/
 */
