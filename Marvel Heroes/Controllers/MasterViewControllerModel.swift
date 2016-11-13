//
//  MasterViewControllerModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 24/7/16.
//  Copyright © 2016 SPM. All rights reserved.
//
import UIKit


protocol cellDelegate : class {
    func updateModel(_ presenter: heroCellPresentable)
}
class MasterViewControllerModel{
    
    // MARK: Properties
    private var _heroes: [Hero]
    var heroes: [Hero] { return _heroes }
    var indexPath: Int = 0
    weak var delegate : cellDelegate?
    var didUpdate: ((heroCellPresentable) -> Void)?

    // MARK: Initialization
    init() {
        _heroes = [Hero]()
    }
    
    convenience init(hero: Hero, theDelegate: cellDelegate ){ //When we want to pass only one element to the cell
        self.init()
        _heroes.append(hero)
        delegate = theDelegate
    }
    
    // MARK: Entry Points to Modify / Query Underlying Model
    func append(_ hero: Hero) {
        _heroes.append(hero)
    }
    
    func removeLast() -> Hero {
        return _heroes.removeLast()
    }
    
    subscript(heroAt index: Int) -> Hero {
        get {
            let hero = _heroes[index]
            //let kk = apiClient.singleton
            //Check if the image is in the cache and download it here if not.
//            if let image = kk.getImage(link: _heroes[index].thumbnailUrl, completion:{_ in print("puta")}){
//            _heroes[index].setPhoto(image: image)
//            }
            return hero
        }
        
        set {
            _heroes[index] = newValue
        }
    }
    
    
}

// MARK: Protocol conformance used to configure the cell for each hero
extension MasterViewControllerModel : TextPresentable {
    var text: String { return heroes[indexPath].name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 10.0) }
}

extension MasterViewControllerModel : ImagePresentable {
    var imageName: String { return heroes[indexPath].thumbnailUrl }
    /* This was incomplete, we should update the images in each cell once they are downloaded */
    
    //TODO: Make this generic
    var image: UIImage {
        let heroUrl = URL(string: heroes[indexPath].thumbnailUrl)
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
                    self?.delegate?.updateModel(self!)
                }
            }
        }
        return heroImage
    }
}
