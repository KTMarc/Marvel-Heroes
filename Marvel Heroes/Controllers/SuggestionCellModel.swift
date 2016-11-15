//
//  SuggestionCellModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 15/11/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit


class SuggestionCellModel {
    
    private var _hero: Hero
    var hero: Hero { return _hero }
    var didUpdate: ((heroCellPresentable) -> Void)?
    
    init() {
        _hero = Hero(name: "", heroId: 0, desc: "", modified: Date() , thumbnailUrl: "")
    }
    
    convenience init(hero: Hero){
        self.init()
        _hero = hero
    }
}

// MARK: ➕ Protocol Extensions conformance used to configure the cell for each hero
extension SuggestionCellModel : TextPresentable {
    var text: String { return hero.name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 12.0) }
}

extension SuggestionCellModel : ImagePresentable {
    var imageName: String { return hero.thumbnailUrl }
    var image: UIImage {
        let heroUrl = URL(string: hero.thumbnailUrl)
        let imageUrl = heroUrl  // For recycled cells' late image loads.
        var heroImage = UIImage()
        if let cachedImage = heroUrl?.cachedImage {
            heroImage = cachedImage
            // Cached: set immediately.
        } else { // Not cached, so load then fade it in.
            
            heroUrl?.fetchImage { [weak self] downloadedImage in
                // Check the cell hasn't recycled while loading.
                if imageUrl?.absoluteString == self?.imageName {
                    heroImage = downloadedImage
                    self?.didUpdate!(self!)
                }
            }
        }
        return heroImage
    }
}

