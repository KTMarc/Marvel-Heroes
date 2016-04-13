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
    private var comics : [Comic] = []

    override init() {
        super.init()
        fetchData(URL_CHARACTERS, offset: 0, notification: NOTIFICATION_HEROES)
    }
    
    func fetchData(endPoint: String, offset: Int, notification: String){
        //Persisting JSON
        let cache = Shared.JSONCache
        let URL = NSURL(string: URL_BASE + endPoint + "?" + "offset=\(offset)&" + URL_CREDENTIALS)!
        print(URL)
        cache.fetch(URL: URL).onSuccess { JSON in
            //print(JSON.dictionary?["data"])
            
            //TODO: this should go in the apiClient
            if (notification == NOTIFICATION_HEROES){
                
                let newElements = parser(data: JSON.dictionary).parseJSON(URL_CHARACTERS)
                self.heroes.appendContentsOf(newElements)
            
            } else if (notification == NOTIFICATION_COMICS){
                
                let newElements = parser(data: JSON.dictionary).parseComics()
                self.comics.appendContentsOf(newElements)
            }
            
            //TODO: This should go in the apiClient
            NSNotificationCenter.defaultCenter().postNotificationName(
                notification, object: self)
            
            } .onFailure { (error) in
                print("Could not fetch from network")
        }
    }
    
    //HEROES
    func getHeroes() -> [Hero] {
//        print("Heroes in getHeroes")
//        print(self.heroes.count)
        return heroes
    }
    
    func getMoreHeroes(offset: Int) {
        fetchData(URL_CHARACTERS, offset: offset, notification: NOTIFICATION_HEROES)
    }
    
    func saveHeroes(heroes: [Hero]) {
    }
    
    //COMICS
    func fetchComics(heroId:Int) {
        fetchData(URL_CHARACTERS + "/\(heroId)/" + URL_COMICS, offset: 0, notification: NOTIFICATION_COMICS)
     
    }
    func getComics() -> [Comic] {
        return comics
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
