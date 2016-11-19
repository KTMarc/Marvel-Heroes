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
    var count: Int { return _comics.count }
    var comicOffset = 0
    var indexPathRow = 0
    weak var delegate : ModelUpdaterDelegate?
    var didUpdate: ((heroCellPresentable) -> Void)?
    var imageAddress: String { return hero.thumbnailUrl }

    // MARK: Initialization 🐣
    init() {
        _hero = Hero(name: "", heroId: 1, desc: "", modified: Date(), thumbnailUrl: "")
        _comics = [Comic]()
    }
    
    convenience init(hero: Hero, theDelegate: ModelUpdaterDelegate){
        self.init()
        _hero = hero
        delegate = theDelegate
    }
    
    /**
     Prepares the the ViewModel.
     Called just one time right after initialization.
     Configures notifications and requests comics to the API
     */
    
    func tearUp(){
        listenToNotifications()
        apiClient.manager.fetchComics(hero.heroId)
    }
    
    // MARK: Entry Points to Modify / Query Underlying Model
    func append(_ comic: Comic) {
        _comics.append(comic)
    }

    subscript(comicAt index: Int) -> Comic {
        let comic = _comics[index]
        return comic
    }
    
    //MARK: API request 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.comics.rawValue), object: nil, queue: nil) {
            
            [weak self] Notification
            //, weak safeDelegate = self.delegate!]*/
            in
            
            self?._comics = apiClient.manager.getComics()
            self?.delegate?.updateModel()
        }
    }
}


// MARK: Protocol conformance used to configure the cell for each comic
extension HeroDetailModel : TextPresentable {
    var text: String { return hero.name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 14.0) }
}

extension HeroDetailModel : ImagePresentable {
    var image: UIImage {
        let initiallySetImageUrl = self.imageAddress // For recycled cells late image loads.
        let entityUrl = URL(string: self.imageAddress)
        //let initiallySetImageUrl = entityUrl  // For recycled cells' late image loads.
        var entityImage = UIImage()
        if let cachedImage = entityUrl?.cachedImage {
            entityImage = cachedImage
            // Cached: set immediately.
        } else { // Not cached, so load then fade it in.
            entityUrl?.fetchImage { [weak self] downloadedImage in
                // Check the cell hasn't recycled while loading.
                if initiallySetImageUrl == self?.imageAddress {
                    entityImage = downloadedImage
                    self?.didUpdate!(self!)
                }
            }
        }
        return entityImage
    }
}
