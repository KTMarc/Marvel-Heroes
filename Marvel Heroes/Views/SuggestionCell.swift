//
//  SuggestionCell.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
//import Haneke

/**
 Custom Cell for Suggestions table view
 */

class SuggestionCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImg: UIImageView!
    
    
    var hero: Hero!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func configureCell(_ hero: Hero) {
        self.hero = hero
        nameLabel.text = self.hero.name.capitalized
        thumbImg.downloadAsyncFrom(self.hero.thumbnailUrl, contentMode: .scaleAspectFill)
//        if let url = NSURL.init(string: self.hero.thumbnailUrl) {
//            thumbImg.hnk_setImageFromURL(url)
//        }
    }
}

