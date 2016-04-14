//
//  ComicCell.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

/**
 Custom Cell for Hero Detail view Collection View of Comics
 */

class ComicCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var comic: Comic!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureCell(comic: Comic) {
        self.comic = comic
        nameLbl.text = self.comic.title
        
        if let url = NSURL.init(string: self.comic.thumbnailUrl) {
            thumbImg.hnk_setImageFromURL(url)
        }
    }
}