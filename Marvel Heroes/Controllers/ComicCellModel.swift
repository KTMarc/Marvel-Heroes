//
//  ComicCellModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/11/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit


class ComicCellModel : ImagePresentable{

    private var _comic: Comic
    var comic: Comic { return _comic }
    var didUpdate: ((heroCellPresentable) -> Void)?
    var imageAddress: String { return comic.thumbnailUrl }
    
    init() {
        _comic = Comic()
    }
    
    convenience init(comic: Comic){
        self.init()
        _comic = comic
    }
}

// MARK: - ➕ Protocol Extensions conformance used to configure the cell for each comic
extension ComicCellModel : TextPresentable {
    var text: String { return comic.title.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 12.0) }
}


