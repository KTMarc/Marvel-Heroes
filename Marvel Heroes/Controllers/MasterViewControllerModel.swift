//
//  MasterViewControllerModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 24/7/16.
//  Copyright © 2016 SPM. All rights reserved.
//
import UIKit

class MasterViewControllerModel{
    
    // MARK: - Properties
    private var _heroes: [Hero]
    var heroes: [Hero] { return _heroes }
    var count: Int { return _heroes.count }
    var indexPathRow: Int = 0
    weak var delegate : ModelUpdaterDelegate?
    var didUpdate: ((heroCellPresentable) -> Void)?

    // MARK: - Initialization
    init() {
        _heroes = [Hero]()
    }
    
    convenience init(theDelegate: ModelUpdaterDelegate){
        self.init()
        delegate = theDelegate
    }
    
    
    // MARK: - API interaction
    func resetHeroSuggestions(){
        apiClient.manager.resetHeroSuggestions()
    }
    
    func moreHeroes(currentOffset: Int){
        apiClient.manager.moreHeroes(currentOffset)
    }
    
    /**
     Prepares the ViewModel.
     Called just one time right after initialization.
     Configures notifications and requests comics to the API
     */
    
    func tearUp(){
        listenToNotifications()
        apiClient.manager.fetchHeroes()
    }
    
    //MARK: - API request 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.heroes.rawValue), object: nil, queue: nil) {  [weak self] Notification in
            
            self?._heroes = apiClient.manager.getHeroes()
            self?.delegate?.updateModel()
        }
    }
    
    subscript(heroAt index: Int) -> Hero {
            return _heroes[index]
    }
}

