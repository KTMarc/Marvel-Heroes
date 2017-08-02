//
//  HeroDetailModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 7/10/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation

class HeroDetailModel : ImagePresentable{
    
    // MARK: - Properties
    private var _hero : Hero!
    var hero: Hero { return _hero }
    
    private var _comics: [Comic]
    var comics: [Comic] { return _comics }
    var count: Int { return _comics.count }
    var comicOffset = 0
    var indexPathRow = 0
    weak var delegate : ModelUpdaterDelegate?
    var didUpdate: ((CellPresentable) -> Void)?
    var imageAddress: String { return hero.thumbnailUrl }

    // MARK: - Initialization 🐣
    init() {
        _hero = Hero()
        _comics = [Comic]()
    }
    
    convenience init(hero: Hero, theDelegate: ModelUpdaterDelegate){
        self.init()
        _hero = hero
        delegate = theDelegate
    }
    
    /**
     Prepares the ViewModel.
     Called just one time right after initialization.
     Configures notifications and requests comics to the API
     */
    
    func tearUp(){
        listenToNotifications()
        apiClient.manager.fetchComics(hero.heroId)
    }
    
    // MARK: - Entry Points to Modify / Query Underlying Model
    func append(_ comic: Comic) {
        _comics.append(comic)
    }

    subscript(comicAt index: Int) -> Comic {
        let comic = _comics[index]
        return comic
    }
    
    //MARK: - API request 📡
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

// MARK: - Protocol conformance used to configure the cell for each comic
extension HeroDetailModel : TextPresentable {
    var text: String { return hero.name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 14.0) }
}

