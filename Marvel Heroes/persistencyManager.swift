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
    private var parse : parser?
    
    override init() {
        super.init()
        if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/heroes.bin")) {
            let unarchiveHeroes = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [Hero]?
            if let unwrappedHero = unarchiveHeroes {
                heroes = unwrappedHero
            }
        } else {
            print("Couldn't find previous file, creating sample data..")
            //createSampleData()
            createJSONCache()
        }
    }
    
    func createSampleData() {
        //Dummy Heroes
        heroes.append(Hero.init(name: "Batman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: NSDate(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"))
        
        heroes.append(Hero.init(name: "Superman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: NSDate(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/8/03/510c08f345938.jpg"))
        //saveHeroes()
    }
    
    func createJSONCache(){
        //Persisting JSON
        let cache = Shared.JSONCache
        let URL = NSURL(string: URL_BASE + URL_CHARACTERS + URL_CREDENTIALS)!
        
        cache.fetch(URL: URL).onSuccess { JSON in
            //print(JSON.dictionary?["data"])
            self.heroes = parser(data: JSON.dictionary).parseJSON()
            print("Heroes in parsing closure")
            print(self.heroes.count)
        }
    }
    
    func getHeroes() -> [Hero] {
        print("Heroes in getHeroes")
        print(self.heroes.count)
        
        return heroes
    }
    
    func saveHeroes(heroes: [Hero]) {
        
    }
    
    
//    func saveHeroes() {
//        let filename = NSHomeDirectory().stringByAppendingString("/Documents/heroes")
//        let data = NSKeyedArchiver.archivedDataWithRootObject(heroes)
//        data.writeToFile(filename, atomically: true)
//    }
    
}
