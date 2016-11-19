//
//  ImagePresentable.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 30/9/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

protocol ImagePresentable : class{
    var imageAddress: String { get }
    var image: UIImage { get }
    var didUpdate: ((heroCellPresentable) -> Void)? { get set }
}


extension ImagePresentable {
    var image: UIImage {
        let initiallySetImageUrl = self.imageAddress // For recycled cells late image loads.
        let entityUrl = URL(string: self.imageAddress)
        //let initiallySetImageUrl = entityUrl  // For recycled cells' late image loads.
        var entityImage = UIImage()
        if let cachedImage = entityUrl?.cachedImage {
            entityImage = cachedImage
            // Cached: set immediately.
        } else { // Not cached, so load then fade it in.
            entityUrl?.fetchImage { [weak self] downloadedImage in
                // Check the cell hasn't recycled while loading.
                if initiallySetImageUrl == self?.imageAddress {
                    entityImage = downloadedImage
                    self?.didUpdate!(self! as! heroCellPresentable)
                }
            }
        }
        return entityImage
    }
}




