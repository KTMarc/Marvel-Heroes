//
//  HeroCellModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/11/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit


class HeroCellModel : ImagePresentable {
    
    private var _hero: Hero
    var hero: Hero { return _hero }
    var didUpdate: ((heroCellPresentable) -> Void)?
    var imageAddress: String { return hero.thumbnailUrl }
    init() {
        _hero = Hero(name: "", heroId: 0, desc: "", modified: Date() , thumbnailUrl: "")
    }
    
    convenience init(hero: Hero){
        self.init()
        _hero = hero
    }
}

// MARK: ➕ Protocol Extensions conformance used to configure the cell for each hero
extension HeroCellModel : TextPresentable {
    var text: String { return hero.name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 12.0) }
}

//extension HeroCellModel : ImagePresentable {
//    var image: UIImage {
//        let initiallySetImageUrl = self.imageAddress // For recycled cells late image loads.
//        let entityUrl = URL(string: self.imageAddress)
//        //let initiallySetImageUrl = entityUrl  // For recycled cells' late image loads.
//        var entityImage = UIImage()
//        if let cachedImage = entityUrl?.cachedImage {
//            entityImage = cachedImage
//            // Cached: set immediately.
//        } else { // Not cached, so load then fade it in.
//            entityUrl?.fetchImage { [weak self] downloadedImage in
//                // Check the cell hasn't recycled while loading.
//                if initiallySetImageUrl == self?.imageAddress {
//                    entityImage = downloadedImage
//                    self?.didUpdate!(self!)
//                }
//            }
//        }
//        return entityImage
//    }
//}
