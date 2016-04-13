//
//  ComicCell.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

class ComicCell: UICollectionViewCell {
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var comic: Comic!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        //layer.cornerRadius = 30.0
        
    }
    
    func configureCell(comic: Comic) {
        self.comic = comic
        nameLbl.text = self.comic.title
        
        if let url = NSURL.init(string: self.comic.thumbnailUrl) {
            //let _ = Shared.imageCache
            
            thumbImg.hnk_setImageFromURL(url)
//            //thumbImg.image = UIImage(data: NSData(contentsOfURL: url)!)
//            thumbImg.layer.borderWidth = 1
//            thumbImg.layer.masksToBounds = false
//            thumbImg.layer.borderColor = UIColor.whiteColor().CGColor
//            //thumbImg.layer.cornerRadius = thumbImg.frame.height / 2
//            thumbImg.layer.cornerRadius = 10
//            thumbImg.clipsToBounds = true
        }
    }
}