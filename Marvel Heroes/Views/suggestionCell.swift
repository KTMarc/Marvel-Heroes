//
//  suggestionCell.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

class suggestionCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImg: UIImageView!
    
    
    var hero: Hero!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configureCell(hero: Hero) {
        self.hero = hero
        nameLabel.text = self.hero.name.capitalizedString
        
        if let url = NSURL.init(string: self.hero.thumbnailUrl) {
            thumbImg.hnk_setImageFromURL(url)
        }
    }
}

