//
//  persistencyManager.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
import Haneke


/**
 Responsible of managing network and local cache of images and JSON files
 Works together with the parser class to serialize objects from JSON.
 */

class PersistencyManager: NSObject {
    private var heroes : [Hero] = []
    private var suggestions : [Hero] = []
    private var comics : [Comic] = []
    private let cache = Shared.JSONCache
    private let _parser : Parser
    private let _storageArchitecture : StorageArchitecture
    
//    override init() {
//        super.init()
//        fetchHeroes()
//    }
    
    init(parseType: ParseType, storageArchitecture: StorageArchitecture){
        _parser = Parser(parseType: parseType)
        _storageArchitecture = storageArchitecture
        super.init()
    }
    
    /**
     Haneke will first attempt to fetch the required JSON from (in order) memory, disk or NSURLCache
     
     - parameter endPoint: API endpoint
     - parameter extra parameters: like 'nameStartsWith='
     - parameter offset: to download the next batch of elements. ex: 0,20,40 ..
     - parameter notification: who should be aware of the task end
     */
    
    func fetchData(endPoint: String, parameter: String, offset: Int, notification: Consts.Notifications){
        
        let URL = NSURL(string: Consts.ApiURL.BASE + endPoint + "?" + "\(parameter)" + "offset=\(offset)&" + Consts.ApiURL.CREDENTIALS)!
        //print(URL)
        
        let mySession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
        let myRequest = NSMutableURLRequest(URL: URL)
        myRequest.HTTPMethod = "GET"
        //let myConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let task = mySession.dataTaskWithRequest(myRequest) { (data, response, error) in

        
        ///Data: NSData
            ///Response: 200,400,etc..
            ///Error
//        cache.fetch(URL: URL)
//            .onSuccess { JSON in
//                self._parser.setDict(JSON.dictionary)
//                
                self._parser.setData(data!)
                switch notification {

                case .heroes:
                    //self._parser.setDict(JSON.dictionary)
                    let newElements = self._parser.parseHeroes("nothing")
                    self.heroes.appendContentsOf(newElements)
                    
                case .comics:
                    //self._parser.setDict(JSON.dictionary)
                    let newElements = self._parser.parseComics()

                    self.comics = newElements
                    
                case .suggestions:
                    //self._parser.setDict(JSON.dictionary)
                    let newElements = self._parser.parseHeroes("nothing")
                    self.suggestions = newElements
                    
                case .modal_heroDetail_dismissed:
                    break
                    
                } //End of switch
                //We completed our job and can the notification can be sent
                NSNotificationCenter.defaultCenter().postNotificationName(
                    notification.rawValue, object: self)
           // } //End of OnSuccess
            
            
//            .onFailure { (error) in
//                print("Could not fetch from network")
//        
//        } //End of onFailure
        
        }
    
        task.resume()
    
        } //End of fecthData
    
    
    
    //MARK: HEROES
    func fetchHeroes(){
        fetchData(Consts.ApiURL.CHARACTERS, parameter: "", offset: 0, notification: Consts.Notifications.heroes)
    }
    
    func getHeroes() -> [Hero] {
        return heroes
    }
    
    func getMoreHeroes(offset: Int) {
        fetchData(Consts.ApiURL.CHARACTERS, parameter: "", offset: offset, notification: Consts.Notifications.heroes)
    }
    
    //MARK: SUGGESTIONS
    
    /**
     API Call example:
     http://gateway.marvel.com/v1/public/characters?nameStartsWith=x-men&ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698
     - parameter keystrokes: The text that user introduced in the searchBar
     */
    
    func searchHeroes(keystrokes: String) {
        
        fetchData(Consts.ApiURL.CHARACTERS, parameter: "nameStartsWith=\(strokeSanitizer(keystrokes))&", offset: 0, notification: Consts.Notifications.suggestions)
    }
    
    func getHeroSuggestions() -> [Hero]{
        return suggestions
    }
    
    func resetHeroSuggestions(){
        suggestions = []
        NSNotificationCenter.defaultCenter().postNotificationName(
            Consts.Notifications.suggestions.rawValue, object: self)
    }
    
    //MARK: COMICS
    /**
     Example API Call:
     http://gateway.marvel.com/v1/public/characters/1010870/comics?offset=0&ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698
     
     - parameter heroId: The Id of the Hero to get the comics from
     */
    
    func fetchComics(heroId:Int) {
        fetchData(Consts.ApiURL.CHARACTERS + "/\(heroId)/" + Consts.ApiURL.COMICS, parameter: "", offset: 0, notification: Consts.Notifications.comics)
        
    }
    
    func getComics() -> [Comic] {
        return comics
    }
    
    /**
     Prevents bad URLs containing spaces
     */
    
    //TODO: Cover more edge cases
    func strokeSanitizer(strokes: String) -> String{
        return strokes.stringByReplacingOccurrencesOfString(" ", withString: "%20")
    }
    
    /**
     Dummy Heroes creation
     */
    func createSampleData() {
        
        heroes.append(Hero.init(name: "Batman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: NSDate(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"))
        
        heroes.append(Hero.init(name: "Superman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: NSDate(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/8/03/510c08f345938.jpg"))
    }
    
    
}
