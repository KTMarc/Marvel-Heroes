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

class HeroCell  : UICollectionViewCell, cellDelegate {
    //MARK: Outlets
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //MARK: Vars
    //Store the last cell imageURL to compare it with the next reused cell
    private var imageUrl: URL!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(_ presenter: heroCellPresentable) {
        
        nameLbl.text = presenter.text
        nameLbl.textColor = presenter.textColor
        DispatchQueue.main.async(execute: { () -> Void in
            self.thumbImg.image = presenter.image
            self.thumbImg.layer.borderWidth = 1
            self.thumbImg.layer.masksToBounds = false
            self.thumbImg.layer.borderColor = UIColor.white.cgColor
            self.thumbImg.layer.cornerRadius = 10
            self.thumbImg.clipsToBounds = true
        })
        ///This could be moved to the viewModel, but then we must update all the cells when we have new images coming.
//        let heroUrl = URL(string: presenter.imageName)
//        imageUrl = heroUrl  // For recycled cells' late image loads.
//        if let image = heroUrl?.cachedImage {
//            // Cached: set immediately.
//            self.thumbImg.image = image
//        } else { // Not cached, so load then fade it in.
//            heroUrl?.fetchImage { [weak self] image in
//            // Check the cell hasn't recycled while downloading this image
//                if self?.imageUrl == heroUrl {
//                    self?.thumbImg.image = image
//                }
//            }
//        }
//        
        
    }
        
        func updateModel(_ presenter: heroCellPresentable) {
            configureCell(presenter)
        }
}
