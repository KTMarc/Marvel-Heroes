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
    var indexPathRow = 0
    weak var delegate : HeroDetailDelegate?
    var didUpdate: ((heroCellPresentable) -> Void)?

    // MARK: Initialization 🐣
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
    
    /**
     Prepares the the ViewModel.
     Called just one time right after initialization.
     Configures notifications and requests comics to the API
     */
    
    func tearUp(){
        listenToNotifications()
        apiClient.singleton.fetchComics(hero.heroId)
    }
    
    // MARK: Entry Points to Modify / Query Underlying Model
    func append(_ comic: Comic) {
        _comics.append(comic)
    }

    subscript(comicAt index: Int) -> Comic {
        let comic = _comics[index]
        return comic
    }
    
    func count() -> Int{
        return _comics.count
    }
    
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
    var text: String { return comics[indexPathRow].title.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 12.0) }
}

extension HeroDetailModel : ImagePresentable {
    var imageName: String { return comics[indexPathRow].thumbnailUrl }
    //TODO: Make this download images async and not make it in the cell.
    
    /* This was incomplete, we should update the images in each cell once they are downloaded */
    var image: UIImage {
        let comic = comics[indexPathRow]
        let comicUrl = URL(string: comic.thumbnailUrl)
        let imageUrl = comicUrl  // For recycled cells' late image loads.
        var comicImage = UIImage()
        if let cachedImage = comicUrl?.cachedImage {
            comicImage = cachedImage
            // Cached: set immediately.
        } else { // Not cached, so load then fade it in.
            comicUrl?.fetchImage { image2 in
                // Check the cell hasn't recycled while loading.
                if imageUrl == comicUrl {
                    comicImage = image2
                }
            }
        }
        return comicImage
    }
}
