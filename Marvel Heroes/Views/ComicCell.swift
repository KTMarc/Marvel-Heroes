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
    //MARK: - Outlets
    @IBOutlet weak var thumbImg: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    //MARK: - Properties
    weak var delegate: CellPresentable?
    
    //MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func presentCell(_ presenter: CellPresentable) {
        //The ViewModel is the delegate, injected in HeroDetailVC
        delegate = presenter
        nameLbl.text = presenter.text
        nameLbl.textColor = presenter.textColor
        DispatchQueue.main.async(execute: { () -> Void in
            self.thumbImg.image = presenter.image
            self.thumbImg.layer.borderWidth = 1
            self.thumbImg.layer.masksToBounds = false
            self.thumbImg.layer.borderColor = UIColor.gray.cgColor
            self.thumbImg.layer.cornerRadius = 5
            self.thumbImg.clipsToBounds = true
        })
        delegate?.didUpdate = self.presentCell
    }
}
