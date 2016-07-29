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
        
        if let url = NSURL.init(string: self.hero.thumbnailUrl) {
            thumbImg.hnk_setImageFromURL(url)
            thumbImg.layer.borderWidth = 1
            thumbImg.layer.masksToBounds = false
            thumbImg.layer.borderColor = UIColor.whiteColor().CGColor
            thumbImg.layer.cornerRadius = 10
            thumbImg.clipsToBounds = true
        }
    }
}