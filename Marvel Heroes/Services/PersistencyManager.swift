//
//  persistencyManager.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
import UIKit

typealias ImageCacheCompletion = (UIImage) -> Void

/**
 Responsible of managing network and local cache of images
 Works together with the parser class to serialize objects from JSON.
 */

class PersistencyManager: NSObject {
    private var _heroes : [Hero] = []
    private var _suggestions : [Hero] = []
    private var _comics : [Comic] = []
    //private let cache = Shared.JSONCache
    private var _parseType: ParseType
    private let _storageArchitecture : StorageArchitecture
    private let _cache = NSCache<NSString,UIImage>()
    private let _mySession = URLSession.shared
    
    init(parseType: ParseType, storageArchitecture: StorageArchitecture){
        _parseType = parseType
        _storageArchitecture = storageArchitecture
        super.init()
    }
    
    /**
     First attempt to fetch the required JSON from (in order) memory, disk or NSURLCache
     
     - parameter endPoint: API endpoint
     - parameter extra parameters: like 'nameStartsWith='
     - parameter offset: to download the next batch of elements. ex: 0,20,40 ..
     - parameter notification: who should be aware of the task end
     */
    
    func fetchData(_ endPoint: String, parameter: String, offset: Int, notification: Consts.Notifications){
        
        let URL = Foundation.URL(string: Consts.ApiURL.BASE + endPoint + "?" + "\(parameter)" + "offset=\(offset)&" + Consts.ApiURL.CREDENTIALS)!
        //print(URL)
        
        let myRequest = URLRequest(url: URL)
        let task = URLSession.shared.dataTask(with: myRequest){ (data, response, error) in
            if let dataa = data {
                switch notification {
                    
                case .heroes:
                    self._heroes.append(contentsOf: Parser(data: dataa, parseType: self._parseType).parseHeroes())
                    
                case .comics:
                    self._comics = Parser(data: dataa, parseType: self._parseType).parseComics()
                    
                case .suggestions:
                    self._suggestions = Parser(data: dataa, parseType: self._parseType).parseHeroes()
                    
                case .modal_heroDetail_dismissed:
                    break
                case .prefetchImages:
                    let prefetchedHeroes = Parser(data: dataa, parseType: self._parseType).parseHeroes()
                    
                    //let operation = Operation()
                    for hero in prefetchedHeroes {
                        self.getImage(link: hero.thumbnailUrl, completion: { image in
                         print("Image \(hero.thumbnailUrl) downloaded")
                        })
                    }
                    //self._heroes.append(contentsOf: prefetchedHeroes)
                    break
                    
                } //End of switch
                //We completed our job and the notification can be sent
                NotificationCenter.default.post(
                    name: Notification.Name(notification.rawValue), object: self)
            } else {
                if let theError = error {
                    print(theError)
                }
            }
            
        }
        task.resume()
    } //End of fecthData
    
    //MARK: - HEROES
    func fetchHeroes(){
        fetchData(Consts.ApiURL.CHARACTERS, parameter: "", offset: 0, notification: Consts.Notifications.heroes)
    }
    
    func getHeroes() -> [Hero] {
        return _heroes
    }
    
    func getHero(id: Int) -> Hero?{
        let hero : [Hero] = _heroes.filter({
            $0.heroId == id
        })
        
        return hero[0]
    }

     func getCache() -> NSCache<NSString,UIImage>{
        return _cache
    }
    
     func getMoreHeroes(_ offset: Int, prefetchingImages: Bool) {
        if prefetchingImages {
            fetchData(Consts.ApiURL.CHARACTERS, parameter: "", offset: offset, notification: Consts.Notifications.prefetchImages)
        } else {
            fetchData(Consts.ApiURL.CHARACTERS, parameter: "", offset: offset, notification: Consts.Notifications.heroes)
        }
    }
    
    //MARK: - SUGGESTIONS
    
    /**
     API Call example:
     http://gateway.marvel.com/v1/public/characters?nameStartsWith=x-men&ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698
     - parameter keystrokes: The text that user introduced in the searchBar
     */
    
     func searchHeroes(_ keystrokes: String) {
        
        fetchData(Consts.ApiURL.CHARACTERS, parameter: "nameStartsWith=\(strokeSanitizer(keystrokes))&", offset: 0, notification: Consts.Notifications.suggestions)
    }
    
    func getHeroSuggestions() -> [Hero]{
        return _suggestions
    }
    
     func resetHeroSuggestions(){
        _suggestions = []
//        NotificationCenter.default.post(
//            name: Notification.Name(rawValue: Consts.Notifications.suggestions.rawValue), object: self)
    }
    
    //MARK: - COMICS
    /**
     Example API Call:
     http://gateway.marvel.com/v1/public/characters/1010870/comics?offset=0&ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698
     
     - parameter heroId: The Id of the Hero to get the comics from
     */
    
     func fetchComics(_ heroId:Int) {
        fetchData(Consts.ApiURL.CHARACTERS + "/\(heroId)/" + Consts.ApiURL.COMICS, parameter: "", offset: 0, notification: Consts.Notifications.comics)
    }
    
    func getComics() -> [Comic] {
        return _comics
    }
    
    /**
     Prevents bad URLs containing spaces
     */
    
    //TODO: Cover more edge cases
     func strokeSanitizer(_ strokes: String) -> String{
        return strokes.replacingOccurrences(of: " ", with: "%20")
    }
    
    /**
    Downloads images and places them in the cache
     */
    
     func getImage(link: String, completion: @escaping ImageCacheCompletion){
        let entityUrl = URL(string: link)
        if (entityUrl?.cachedImage) != nil {
            return
        } else {
            entityUrl?.fetchImage(completion: { (image) in
                return
            })
        }
    }
    
    /**
     Dummy Heroes creation
     */
     func createSampleData() {
        
        _heroes.append(Hero.init(name: "Batman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: Date(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"))
        
        _heroes.append(Hero.init(name: "Superman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: Date(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/8/03/510c08f345938.jpg"))
    }
}
