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

typealias heroCellPresentable = TextPresentable & ImagePresentable


    class HeroCell  : UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //Store the last cell imageURL to compare it with the next reused cell
    private var imageUrl: URL!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(_ presenter: heroCellPresentable) {
        
        nameLbl.text = presenter.text
        nameLbl.textColor = presenter.textColor
        //thumbImg.image = presenter.image
        
        ///This could be moved to the viewModel, but then we must update all the cells when we have new images coming.
        let heroUrl = URL(string: presenter.imageName)
        imageUrl = heroUrl  // For recycled cells' late image loads.
        if let image = heroUrl?.cachedImage {
            // Cached: set immediately.
            self.thumbImg.image = image
        } else { // Not cached, so load then fade it in.
            heroUrl?.fetchImage { [weak self] image in
            // Check the cell hasn't recycled while loading.
                if self?.imageUrl == heroUrl {
                    self?.thumbImg.image = image
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
