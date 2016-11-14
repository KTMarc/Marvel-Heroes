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

protocol HeroBrowserDelegate : class {
    func updateModel()
}

class MasterViewControllerModel{
    
    // MARK: Properties
    private var _heroes: [Hero]
    var heroes: [Hero] { return _heroes }
    var count: Int { return _heroes.count }
    var indexPathRow: Int = 0
    weak var delegate : HeroBrowserDelegate?
    var didUpdate: ((heroCellPresentable) -> Void)?

    // MARK: Initialization
    init() {
        _heroes = [Hero]()
    }
    
    convenience init(theDelegate: HeroBrowserDelegate){
        self.init()
        delegate = theDelegate
    }
    
    // MARK: Entry Points to Modify / Query Underlying Model
    //TODO: Check if this could be deleted
    func append(_ hero: Hero) {
        _heroes.append(hero)
    }
    
//    func count() -> Int {
//        return _heroes.count
//    }
    
    //TODO: Check if this could be deleted
    func removeLast() -> Hero {
        return _heroes.removeLast()
    }
    
    // MARK: API interaction
    func search(keystrokes: String){
        apiClient.singleton.searchHeroes(keystrokes)
    }
    
    func resetHeroSuggestions(){
        apiClient.singleton.resetHeroSuggestions()
    }
    
    /**
     Prepares the the ViewModel.
     Called just one time right after initialization.
     Configures notifications and requests comics to the API
     */
    
    func tearUp(){
        listenToNotifications()
        apiClient.singleton.fetchHeroes()
    }
    
    //MARK: API request 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.heroes.rawValue), object: nil, queue: nil) {  [weak self] Notification in
            
            self?._heroes = apiClient.singleton.getHeroes()
            self?.delegate?.updateModel()
        }
    }
    
    subscript(heroAt index: Int) -> Hero {
            return _heroes[index]
    }
}

// MARK: Protocol conformance used to configure the cell for each hero
extension MasterViewControllerModel : TextPresentable {
    var text: String { return heroes[indexPathRow].name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 10.0) }
}

extension MasterViewControllerModel : ImagePresentable {
    var imageName: String { return heroes[indexPathRow].thumbnailUrl }
   
    //TODO: Make this generic
    var image: UIImage {
        let heroUrl = URL(string: heroes[indexPathRow].thumbnailUrl)
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
                }
            }
        }
        return heroImage
    }
}
