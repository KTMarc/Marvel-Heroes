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
    private var indexPathRow: Int = 0
    private var sectionCount: Int = 0
    private var _currentOffset = 0
    weak var delegate : ModelUpdaterDelegate?
    var didUpdate: ((heroCellPresentable) -> Void)?
    
    var heroes: [Hero] { return _heroes }
    var count: Int { return _heroes.count }
    
    // MARK: - Initialization
    init() {
        _heroes = [Hero]()
    }
    
    convenience init(theDelegate: ModelUpdaterDelegate){
        self.init()
        delegate = theDelegate
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
    
    // MARK: - API interaction
    func resetHeroSuggestions(){
        apiClient.manager.resetHeroSuggestions()
    }
    
    func moreHeroes(){
        apiClient.manager.moreHeroes(_currentOffset, prefetchingImages: false)
    }
    
    func prefetch(moreIndexPaths: Int){
        apiClient.manager.moreHeroes(_currentOffset + moreIndexPaths, prefetchingImages: true)
    }
    
    // MARK: Access to collection elements
    func indexIsValid(row: Int, section: Int) -> Bool {
        return row >= 0 && row < count && section >= 0 && section < sectionCount
    }
    
    subscript(indexPath: IndexPath) -> Hero {
        get {
            indexPathRow = indexPath.row
         //   assert(indexIsValid(row: indexPath.row, section: indexPath.section), "Index out of range")
            if (indexPath.item == (count - 8)) && (count > _currentOffset){
                _currentOffset += 20
                moreHeroes()
            }
        return _heroes[indexPath.row]
        }
    }
    
    
    //MARK: - API request 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.heroes.rawValue), object: nil, queue: nil) {  [weak self] Notification in
            //TODO: Show some empty state when nothing was returned for lack of internet connection
            self?._heroes = apiClient.manager.getHeroes()
            self?.delegate?.updateModel()
        }
    }
    
    subscript(heroAt index: Int) -> Hero {
            return _heroes[index]
    }
}

