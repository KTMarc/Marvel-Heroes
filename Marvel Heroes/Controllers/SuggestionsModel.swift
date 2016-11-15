//
//  SuggestionsModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 15/11/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit


class SuggestionsModel{
    
    // MARK: Properties
    private var _heroes: [Hero]
    var heroes: [Hero] { return _heroes }
    var count: Int { return _heroes.count }
    var indexPathRow: Int = 0
    weak var delegate : ModelUpdaterDelegate?
    var didUpdate: ((heroCellPresentable) -> Void)?
    
    // MARK: Initialization
    init() {
        _heroes = [Hero]()
    }
    
    convenience init(theDelegate: ModelUpdaterDelegate){
        self.init()
        delegate = theDelegate
    }
    
    func tearUp(){
        listenToNotifications()
    }
    
    subscript(heroAt index: Int) -> Hero {
        return _heroes[index]
    }
    
    //MARK: API request 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.suggestions.rawValue), object: nil, queue: nil) { [weak self] Notification in
            
            self?._heroes = apiClient.manager.getHeroSuggestions()
            self?.delegate?.updateModel()
        }
    }
    
}

// MARK: Protocol conformance used to configure the cell for each hero
extension SuggestionsModel : TextPresentable {
    var text: String { return heroes[indexPathRow].name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 10.0) }
}

extension SuggestionsModel : ImagePresentable {
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
