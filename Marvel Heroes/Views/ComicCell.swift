//
//  ComicCell.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

/**
 Custom Cell for Hero Detail view Collection View of Comics
 */

class ComicCell: UICollectionViewCell {
    //MARK: Outlets
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //MARK: Properties
    private var delegate: heroCellPresentable?
    
    //MARK: Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func presentCell(_ presenter: heroCellPresentable) {
        delegate = presenter
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
        delegate?.didUpdate = self.presentCell
    }
}
