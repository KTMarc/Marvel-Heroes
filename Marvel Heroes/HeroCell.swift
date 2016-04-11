//
//  HeroCell.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

class HeroCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var hero: Hero!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //layer.cornerRadius = 30.0
        
    }
    
    func configureCell(hero: Hero) {
        self.hero = hero
        nameLbl.text = self.hero.name.capitalizedString
        
        if let url = NSURL.init(string: self.hero.thumbnailUrl) {
            thumbImg.hnk_setImageFromURL(url)
            self.thumbImg.layer.cornerRadius = self.thumbImg.frame.size.width / 2;
            self.thumbImg.clipsToBounds = true
        }
    }
}