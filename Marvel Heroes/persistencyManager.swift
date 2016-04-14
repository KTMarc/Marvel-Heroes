//
//  persistencyManager.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
import Haneke

class PersistencyManager: NSObject {
    private var heroes : [Hero] = []
    private var suggestions : [Hero] = []
    private var comics : [Comic] = []
    private let cache = Shared.JSONCache

    override init() {
        super.init()
        fetchHeroes()
    }
    
    func fetchData(endPoint: String, parameter: String, offset: Int, notification: String){
        //Persisting JSON

        let URL = NSURL(string: URL_BASE + endPoint + "?" + "\(parameter)" + "offset=\(offset)&" + URL_CREDENTIALS)!
        print(URL)
        cache.fetch(URL: URL).onSuccess { JSON in
            //print(JSON.dictionary?["data"])
            
            //TODO: this should go in the apiClient
            switch(notification){
            case NOTIFICATION_HEROES:
                
                let newElements = parser(data: JSON.dictionary).parseJSON(URL_CHARACTERS)
                self.heroes.appendContentsOf(newElements)
                break
                
            case NOTIFICATION_COMICS:
                
                let newElements = parser(data: JSON.dictionary).parseComics()
                self.comics = newElements
                break
                
            case NOTIFICATION_SUGGESTIONS:
                let newElements = parser(data: JSON.dictionary).parseJSON(URL_CHARACTERS)
                self.suggestions = newElements
                break
                
            default:
                break
            }
            
            //TODO: This should go in the apiClient
            NSNotificationCenter.defaultCenter().postNotificationName(
                notification, object: self)
            
            } .onFailure { (error) in
                print("Could not fetch from network")
        }
    }
    
    
    //HEROES
    func fetchHeroes(){
        fetchData(URL_CHARACTERS, parameter: "", offset: 0, notification: NOTIFICATION_HEROES)
    }
    
    func getHeroes() -> [Hero] {
        return heroes
    }
    
    func getMoreHeroes(offset: Int) {
        fetchData(URL_CHARACTERS, parameter: "", offset: offset, notification: NOTIFICATION_HEROES)
    }
    
    //SUGGESTIONS FOR HEROES
    func searchHeroes(keystrokes: String) {
        //http://gateway.marvel.com/v1/public/characters?nameStartsWith=x-men&ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698
        
        fetchData(URL_CHARACTERS, parameter: "nameStartsWith=\(strokeSanitizer(keystrokes))&", offset: 0, notification: NOTIFICATION_SUGGESTIONS)
    }
    
    func getHeroSuggestions() -> [Hero]{
     return suggestions
    }
    
    func resetHeroSuggestions(){
        suggestions = []
        NSNotificationCenter.defaultCenter().postNotificationName(
            NOTIFICATION_SUGGESTIONS, object: self)
    }
    
    //COMICS
    func fetchComics(heroId:Int) {
        //Clean cache first
//        Shared.imageCache.removeAll()
        //http://gateway.marvel.com/v1/public/characters/1010870/comics?offset=0&ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698
        
        fetchData(URL_CHARACTERS + "/\(heroId)/" + URL_COMICS, parameter: "", offset: 0, notification: NOTIFICATION_COMICS)
     
    }
    func getComics() -> [Comic] {
        return comics
    }
    
    func strokeSanitizer(strokes: String) -> String{
        
        let sanitizedStrokes = strokes.stringByReplacingOccurrencesOfString(" ", withString: "%20")
        
        return sanitizedStrokes
    }
//    func saveHeroes() {
//        let filename = NSHomeDirectory().stringByAppendingString("/Documents/heroes")
//        let data = NSKeyedArchiver.archivedDataWithRootObject(heroes)
//        data.writeToFile(filename, atomically: true)
//    }
    
//    func createSampleData() {
//        //Dummy Heroes
//        heroes.append(Hero.init(name: "Batman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: NSDate(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"))
//        
//        heroes.append(Hero.init(name: "Superman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: NSDate(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/8/03/510c08f345938.jpg"))
//        //saveHeroes()
//    }
//    
    
}
