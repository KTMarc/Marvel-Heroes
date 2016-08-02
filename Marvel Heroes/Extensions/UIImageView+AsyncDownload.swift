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
    func downloadAsyncFrom(link: String, contentMode mode: UIViewContentMode) {
        guard let url = NSURL(string: link) else { return }
        contentMode = mode
        let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else { return }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.image = image
            })
        }
        task.resume()
    }
}

/*
 Make it better adding cache and detection of visible cells on the screen
 http://sweettutos.com/2015/12/31/swift-how-to-asynchronously-download-and-cache-images-without-relying-on-third-party-libraries/
 */
