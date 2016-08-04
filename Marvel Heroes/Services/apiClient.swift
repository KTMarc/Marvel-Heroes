//
//  apiClient.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation

/**
 Visible Interface for the View Controllers
 Behind it there are other entities that are not accessible for them
 */

// MARK: Types

/**
 Select different ways of doing things.
 It enforces thinking in a modular way to exchange the logic when necessary
 */

enum ParseType {
    case swifty
    case functional
}

enum StorageArchitecture {
    case haneke
    case other
}

class apiClient: NSObject {
    
    // MARK: Properties
    private let persistencyManager: PersistencyManager
    private let isOnline: Bool
    private let _parseType: ParseType
    private let _storageArchitecture : StorageArchitecture

    class var sharedInstance: apiClient {
        struct Singleton {
            static let instance = apiClient(parseType: .functional, storageArchitecture: .haneke)
        }
        return Singleton.instance
    }

    init(parseType: ParseType, storageArchitecture: StorageArchitecture) {
        _parseType = parseType
        _storageArchitecture = storageArchitecture
        persistencyManager = PersistencyManager(parseType: _parseType, storageArchitecture: _storageArchitecture)
        isOnline = false
        super.init()
    }
    
    //MARK: HEROES
    
    /**
     Example API Call:
     http://gateway.marvel.com/v1/public/characters/1010870/comics?offset=0&ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698
     
     - parameter heroId: The Id of the Hero to get the comics from
     */
    
    func fetchHeroes(){
        return persistencyManager.fetchHeroes()
    }
    
    /**
     Returns the list of previously fetched elements
     - returns: An array of heroes
     */
    
    func getHeroes() -> [Hero]{
        return persistencyManager.getHeroes()
    }
    
    /**
    Fetches more elements with a given offset
     - parameter offset: An int representing the next batch start: 0, 20, 40
     - returns: An array of comics
     */
    
    func moreHeroes(_ offset: Int){
        persistencyManager.getMoreHeroes(offset)
    }
    
    
    //MARK: SUGGESTIONS
    
    /**
     Finds characters matching name
     - parameter keystrokes: The text that user introduced in the searchBar
     */
    
    func searchHeroes(_ keystrokes: String){
        return persistencyManager.searchHeroes(keystrokes)
    }
    
    /**
     Returns the list of previously fetched Heroes
     - returns: An array of characters
     */
    
    func getHeroSuggestions() -> [Hero]{
        return persistencyManager.getHeroSuggestions()
    }
    
    /**
     Cleans the Suggestions Ciew Controller and leaves it ready for the next keystroke or deletion
     */
    
    func resetHeroSuggestions(){
        return persistencyManager.resetHeroSuggestions()
    }
    
    
    
    
    //MARK: COMICS
    
    /**
     Starts the loading process for a particular Character Comic list
     
     - parameter heroId: The Id of the Hero to get the comics from
     */
    
    func fetchComics(_ heroId: Int){
         persistencyManager.fetchComics(heroId)
    }
    
    /**
     Returns the list of previously fetched elements
     - returns: An array of comics
     */
    
    func getComics() -> [Comic]{
        return persistencyManager.getComics()
    }

}
