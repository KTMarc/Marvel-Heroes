//
//  SuggestionCell.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

/**
 Custom Cell for Suggestions table view
 */

class SuggestionCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbImg: UIImageView!
    
    //MARK: - Properties
    weak var delegate: CellPresentable?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    func presentCell(_ presenter: CellPresentable) {
        delegate = presenter
        nameLabel.text = presenter.text.capitalized
        DispatchQueue.main.async(execute: { () -> Void in
            self.thumbImg.image = presenter.image
            self.thumbImg.contentMode = .scaleAspectFill
        })
        delegate?.didUpdate = self.presentCell
    }
}

