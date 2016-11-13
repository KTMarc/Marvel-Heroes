//
//  ComicCellModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/11/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit


class ComicCellModel {

    private var _comic: Comic
    var comic: Comic { return _comic }
    var didUpdate: ((heroCellPresentable) -> Void)?
    
    init() {
        _comic = Comic(title: "", comicId: 0, thumbnailUrl: "")
    }
    
    convenience init(comic: Comic){
        self.init()
        _comic = comic
    }
}

// MARK: ➕ Protocol Extensions conformance used to configure the cell for each comic
extension ComicCellModel : TextPresentable {
    var text: String { return comic.title.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 12.0) }
}

extension ComicCellModel : ImagePresentable {
    var imageName: String { return comic.thumbnailUrl }
    var image: UIImage {
        let comicUrl = URL(string: comic.thumbnailUrl)
        let imageUrl = comicUrl  // For recycled cells' late image loads.
        var comicImage = UIImage()
        if let cachedImage = comicUrl?.cachedImage {
            comicImage = cachedImage
            // Cached: set immediately.
        } else { // Not cached, so load then fade it in.
            
            comicUrl?.fetchImage { [weak self] downloadedImage in
                // Check the cell hasn't recycled while loading.
                if imageUrl?.absoluteString == self?.imageName {
                    comicImage = downloadedImage
                    self?.didUpdate!(self!)
                }
            }
        }
        return comicImage
    }
}

