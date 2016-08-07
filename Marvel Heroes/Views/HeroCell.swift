//
//  HeroCell.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

/**
 Custom Cell for Master table view
 */

class HeroCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    private var hero: Hero!
    private var imageUrl: URL!

    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(_ hero: Hero) {
        self.hero = hero
        nameLbl.text = self.hero.name.capitalized
        //FIXME: This should happen in the ViewModel
        //thumbImg.downloadAsyncFrom(self.hero.thumbnailUrl, contentMode: .scaleAspectFill)
        //thumbImg.image = self.hero.getPhoto()
        //_ = apiClient.sharedInstance.getImage(link: self.hero.thumbnailUrl, completion: { downloadedImage in
            //self.thumbImg.image = downloadedImage })
    
        let heroUrl = URL(string: self.hero.thumbnailUrl)
        print(hero.thumbnailUrl)
        print(heroUrl!.absoluteString)
        // Image loading.
        self.imageUrl = heroUrl  // For recycled cells' late image loads.
        if let image = heroUrl?.cachedImage {
            // Cached: set immediately.
            self.thumbImg.image = image
           // self.thumbImg.alpha = 1
        } else {
            // Not cached, so load then fade it in.
            //self.thumbImg.alpha = 0
           // self.thumbImg.image = UIImage(named: "imgres")
            heroUrl?.fetchImage { image in
                // Check the cell hasn't recycled while loading.
                if self.imageUrl == heroUrl {
                    self.thumbImg.image = image
//                    UIView.animate(withDuration: 0.3) {
//                        self.thumbImg.alpha = 1
//                    }
                }
            }
        }
        
        thumbImg.layer.borderWidth = 1
        thumbImg.layer.masksToBounds = false
        thumbImg.layer.borderColor = UIColor.white.cgColor
        thumbImg.layer.cornerRadius = 10
        thumbImg.clipsToBounds = true
    }
}
