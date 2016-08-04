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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(_ hero: Hero) {
        self.hero = hero
        nameLbl.text = self.hero.name.capitalized
        //FIXME: This should happen in the ViewModel
        thumbImg.downloadAsyncFrom(self.hero.thumbnailUrl, contentMode: .scaleAspectFill)
        thumbImg.layer.borderWidth = 1
        thumbImg.layer.masksToBounds = false
        thumbImg.layer.borderColor = UIColor.white.cgColor
        thumbImg.layer.cornerRadius = 10
        thumbImg.clipsToBounds = true
    }
}
