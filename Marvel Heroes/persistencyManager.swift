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
    

    override init() {
        super.init()
        fetchData(URL_CHARACTERS, offset: 0)
    }
    
    func fetchData(endPoint: String, offset: Int){
        //Persisting JSON
        let cache = Shared.JSONCache
        let URL = NSURL(string: URL_BASE + endPoint + "?" + "offset=\(offset)&" + URL_CREDENTIALS)!
        print(URL)
        cache.fetch(URL: URL).onSuccess { JSON in
            //print(JSON.dictionary?["data"])
            
            //TODO: this should go in the apiClient
            self.heroes = parser(data: JSON.dictionary).parseJSON()
            
            //TODO: This should go in the apiClient
            NSNotificationCenter.defaultCenter().postNotificationName(
                "heroesDownloadedNotification", object: self)
            
            } .onFailure { (error) in
                print("Could not fetch from network")
        }
    }
    

    func getHeroes() -> [Hero] {
//        print("Heroes in getHeroes")
//        print(self.heroes.count)
        return heroes
    }
    
    func getMoreHeroes() {
        fetchData(URL_CHARACTERS, offset: 20)
    }
    
    func saveHeroes(heroes: [Hero]) {
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
