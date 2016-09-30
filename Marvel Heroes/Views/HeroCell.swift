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

protocol TextPresentable {
   var text: String { get }
   var textColor: UIColor { get }
   var font: UIFont { get }
}
    
protocol ImagePresentable {
   var imageName: String { get }
}
    
typealias CellTextViewPresentable = TextPresentable & ImagePresentable

    
    class HeroCell  : UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //Store the last cell imageURL to compare it with the next reused cell
    private var imageUrl: URL!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(_ presenter: CellTextViewPresentable) {
        
        nameLbl.text = presenter.text.capitalized
        let heroUrl = URL(string: presenter.imageName)
        imageUrl = heroUrl  // For recycled cells' late image loads.
        if let image = heroUrl?.cachedImage {
            // Cached: set immediately.
            self.thumbImg.image = image
        } else { // Not cached, so load then fade it in.
            heroUrl?.fetchImage { image in
            // Check the cell hasn't recycled while loading.
                if self.imageUrl == heroUrl {
                    self.thumbImg.image = image
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
