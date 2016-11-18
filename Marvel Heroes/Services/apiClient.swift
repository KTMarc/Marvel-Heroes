//
//  apiClient.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
import UIKit

/**
  Using the FAÇADE DESIGN PATTERN, which provides a single interface to a complex subsystem. Instead of exposing the user to a set of classes and their APIs, you only expose one simple unified API
 */

// MARK: Types

/**
 Select different ways of doing tasks.
 It enforces thinking in a modular way to exchange the logic when necessary
 So, we can have at some point different implementations of:
 -Parser: with legacy JSON Serializer, SwiftyJSON, Gloss, etc..
 -Storage Manager: Legacy NSCache, Haneke, Core Data, Realm, etc..
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
    private let _persistencyManager: PersistencyManager
    private let _isOnline: Bool
    private let _parseType: ParseType
    private let _storageArchitecture : StorageArchitecture

    //Singleton definition:
    //supports lazy initialization because Swift lazily initializes class constants (and variables), and is thread safe by the definition of let
    static let manager = apiClient(parseType: .functional, storageArchitecture: .other)
    
    init(parseType: ParseType, storageArchitecture: StorageArchitecture) {
        _parseType = parseType
        _storageArchitecture = storageArchitecture
        _persistencyManager = PersistencyManager(parseType: _parseType, storageArchitecture: _storageArchitecture)
        _isOnline = false
        super.init()
    }
    
    //MARK: IMAGES
    func getImage(link: String, completion: ImageCacheCompletion) -> UIImage?{
        return _persistencyManager.getImage(link: link, completion: { (image) in
            print("imagen bajada")
        })
    }
    
    func getCache() -> NSCache<NSString,UIImage>{
        return _persistencyManager.getCache()
    }
    
    
    //MARK: HEROES
    /**
     Example API Call:
     http://gateway.marvel.com/v1/public/characters/1010870/comics?offset=0&ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698
     
     - parameter heroId: The Id of the Hero to get the comics from
     */
    
    func fetchHeroes() {
         _persistencyManager.fetchHeroes()
    }
    
    /**
      Given a given ID we seach a Hero
     - returns: A Hero or Nil
     */
    
    func getHero(id: Int) -> Hero?{
        return _persistencyManager.getHero(id: id)
    }
    
    /**
     Returns the list of previously fetched elements
     - returns: An array of heroes
     */
    
    func getHeroes() -> [Hero]{
        return _persistencyManager.getHeroes()
    }
    
    /**
     Returns a specific Hero
     - returns: A Hero or Nil if we didn´t find it
     */
//    func getHero(id: Int) -> Hero{
//        return persistencyManager.getHero(id: id)!
//    }
//    
    /**
    Fetches more elements with a given offset
     - parameter offset: An int representing the next batch start: 0, 20, 40
     - returns: An array of comics
     */
    
    func moreHeroes(_ offset: Int){
        _persistencyManager.getMoreHeroes(offset)
    }
    
    
    //MARK: SUGGESTIONS
    
    /**
     Finds characters matching name
     - parameter keystrokes: The text that user introduced in the searchBar
     */
    
    func searchHeroes(_ keystrokes: String){
        return _persistencyManager.searchHeroes(keystrokes)
    }
    
    /**
     Returns the list of previously fetched Heroes
     - returns: An array of characters
     */
    
    func getHeroSuggestions() -> [Hero]{
        return _persistencyManager.getHeroSuggestions()
    }
    
    /**
     Cleans the Suggestions View Controller and leaves it ready for the next keystroke or deletion
     */
    
    func resetHeroSuggestions(){
        return _persistencyManager.resetHeroSuggestions()
    }
    
    
    
    //MARK: COMICS
    
    /**
     Starts the loading process for a particular Character Comic list
     
     - parameter heroId: The Id of the Hero to get the comics from
     */
    
    func fetchComics(_ heroId: Int){
         _persistencyManager.fetchComics(heroId)
    }
    
    /**
     Returns the list of previously fetched elements
     - returns: An array of comics
     */
    
    func getComics() -> [Comic]{
        return _persistencyManager.getComics()
    }

}
