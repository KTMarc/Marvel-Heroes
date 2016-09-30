//
//  MasterViewControllerModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 24/7/16.
//  Copyright © 2016 SPM. All rights reserved.
//
import UIKit

struct MasterViewControllerModel {
    
    // MARK: Properties
    private var _heroes: [Hero]
    var heroes: [Hero] { return _heroes }
    var indexPath: Int = 0
    
    // MARK: Initialization
    init() {
        _heroes = [Hero]()
    }
    
    init(hero: Hero){ //When we want to pass only one element to the cell
        self.init()
        _heroes.append(hero)
    }
    
    // MARK: Entry Points to Modify / Query Underlying Model
    mutating func append(_ hero: Hero) {
        _heroes.append(hero)
    }
    
    mutating func removeLast() -> Hero {
        return _heroes.removeLast()
    }
    
    subscript(heroAt index: Int) -> Hero {
        mutating get {
          
            //let kk = apiClient.singleton
            //Check if the image is in the cache and download it here if not.
//            if let image = kk.getImage(link: _heroes[index].thumbnailUrl, completion:{_ in print("puta")}){
//            _heroes[index].setPhoto(image: image)
//            }
            return _heroes[index]
        }
        
        set {
            _heroes[index] = newValue
        }
    }
}

// MARK: Protocol conformance
extension MasterViewControllerModel : TextPresentable {
    var text: String { return heroes[indexPath].name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 8.0) }
}

extension MasterViewControllerModel : ImagePresentable {
    var imageName: String { return heroes[indexPath].thumbnailUrl }
}
