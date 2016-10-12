//
//  HeroDetailModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 7/10/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

class HeroDetailModel {
    
    // MARK: Properties
    private var _hero : Hero!
    var hero: Hero { return _hero }
    
    private var _comics: [Comic]
    var comics: [Comic] { return _comics }
    
    var comicOffset = 0
    var indexPath: Int = 0
    weak var delegate : HeroDetailDelegate?
    
    // MARK: Initialization
    init() {
        _hero = Hero(name: "", heroId: 1, desc: "", modified: Date(), thumbnailUrl: "")
        _comics = [Comic]()
    }
    
    convenience init(hero: Hero, theDelegate: HeroDetailDelegate){
        self.init()
        _hero = hero
        _comics = [Comic]()
        delegate = theDelegate
    }
    
    
    func tearUp(){
        listenToNotifications()
        //Ask for comics
        apiClient.singleton.fetchComics(hero.heroId)
    }
    
    func tearDown(){
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Entry Points to Modify / Query Underlying Model
    func append(_ comic: Comic) {
        _comics.append(comic)
    }

    /*
    subscript(comicAt index: Int) -> Comic {
        mutating get {
            let comic = _comics[index]
            //let kk = apiClient.singleton
            //Check if the image is in the cache and download it here if not.
            //            if let image = kk.getImage(link: _heroes[index].thumbnailUrl, completion:{_ in print("puta")}){
            //            _heroes[index].setPhoto(image: image)
            //            }
            return comic
        }
        
        set {
            _comics[index] = newValue
        }
    }*/
    //MARK: API request 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.comics.rawValue), object: nil, queue: nil) {
            
            [weak self] Notification
            //, weak safeDelegate = self.delegate!]*/
            in
            
            self?._comics = apiClient.singleton.getComics()
            //print("Received Comics: \(self._comics.count)")
            //safeDelegate?.updateModel()
            self?.delegate?.updateModel()
        }
    }
}


// MARK: Protocol conformance used to configure the cell for each comic
extension HeroDetailModel : TextPresentable {
    var text: String { return comics[indexPath].title.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 10.0) }
}

extension HeroDetailModel : ImagePresentable {
    var imageName: String { return comics[indexPath].thumbnailUrl }
    /* This was incomplete, we should update the images in each cell once they are downloaded
     var image: UIImage {
     let hero = heroes[indexPath]
     let heroUrl = URL(string: hero.thumbnailUrl)
     let imageUrl = heroUrl  // For recycled cells' late image loads.
     var heroImage = UIImage()
     if let cachedImage = heroUrl?.cachedImage {
     heroImage = cachedImage
     // Cached: set immediately.
     } else { // Not cached, so load then fade it in.
     heroUrl?.fetchImage { image2 in
     // Check the cell hasn't recycled while loading.
     if imageUrl == heroUrl {
     heroImage = image2
     }
     }
     }
     return heroImage
     }*/
}
