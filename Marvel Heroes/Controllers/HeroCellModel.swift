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
    var didUpdate: ((CellPresentable) -> Void)?
    var imageAddress: String { return hero.thumbnailUrl }
    init() {
        _hero = Hero()
    }
    
    convenience init(hero: Hero){
        self.init()
        _hero = hero
    }
    
    deinit {
        print("\(self.text) CellViewModel is being deinitialized with reatain count \(CFGetRetainCount(self))")
    }
}

// MARK: - ➕ Protocol Extensions conformance used to configure the cell for each hero
extension HeroCellModel : TextPresentable {
    var text: String { return hero.name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 12.0) }
}

