//
//  SuggestionsModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 15/11/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit


class SuggestionsModel : ImagePresentable{
    
    // MARK: - Properties
    private var _heroes: [Hero]
    var heroes: [Hero] { return _heroes }
    var count: Int { return _heroes.count }
    var indexPathRow: Int = 0
    weak var delegate : ModelUpdaterDelegate?
    var didUpdate: ((heroCellPresentable) -> Void)?
    var imageAddress: String { return heroes[indexPathRow].thumbnailUrl }
    
    // MARK: - Initialization
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
    
    func flushHeroes(){
        _heroes = [Hero]()
    }
    
    func search(keystrokes: String){
        apiClient.manager.searchHeroes(keystrokes)
    }
        
    subscript(heroAt index: Int) -> Hero {
        return _heroes[index]
    }
    
    //MARK: - API request 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.suggestions.rawValue), object: nil, queue: nil) { [weak self] Notification in
            
            self?._heroes = apiClient.manager.getHeroSuggestions()
            if (self?._heroes.count == 0) {
                self?._heroes.append(Hero(name: "NO HEROES FOUND   ¯\\_(ツ)_/¯ ", heroId: 0 , desc: nil, modified: Date() , thumbnailUrl: ""))
            }
            self?.delegate?.updateModel()
        }
    }
    
}

// MARK: - Protocol conformance used to configure the cell for each hero
extension SuggestionsModel : TextPresentable {
    var text: String { return heroes[indexPathRow].name.capitalized }
    var textColor: UIColor { return .white }
    var font: UIFont { return .systemFont(ofSize: 10.0) }
}

