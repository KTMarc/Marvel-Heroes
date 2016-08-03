//
//  HeroCell.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

/**
 Custom Cell for Master table view
 */

class HeroCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    private var hero: Hero!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(hero: Hero) {
        self.hero = hero
        nameLbl.text = self.hero.name.capitalizedString
        
        
         guard let url = NSURL.init(string: self.hero.thumbnailUrl) else { print("Not a valid url"); return}
        
        
        /*Stack trace for retrieval of image:
         (UIMageView+Haneke.swift)
         UIImageView.hnk_setImageFromURL -> 
            UIImageView.hnk_setImageFromFetcher -> 
                UIImageView.hnk_fetchImageForFetcher ->
                 let cache = Shared.imageCache (we acces the singleton that holds the shared cache)
                    (Haneke.swift) 
                        static Shared.imageCache.getter
         */
            thumbImg.hnk_setImageFromURL(url)
        
        /*
         https://github.com/Haneke/HanekeSwift
         
         The above line take care of:
         
         If cached, retrieving an appropriately sized image (based on the bounds and contentMode of the UIImageView) from the memory or disk cache. Disk access is performed in background.
         If not cached, loading the original image from web/memory and producing an appropriately sized image, both in background. Remote images will be retrieved from the shared NSURLCache if available.
         Setting the image and animating the change if appropriate.
         Or doing nothing if the UIImageView was reused during any of the above steps.
         Caching the resulting image.
         If needed, evicting the least recently used images in the cache.
         
         */
        
            thumbImg.layer.borderWidth = 1
            thumbImg.layer.masksToBounds = false
            thumbImg.layer.borderColor = UIColor.whiteColor().CGColor
            thumbImg.layer.cornerRadius = 10
            thumbImg.clipsToBounds = true
    }
}
