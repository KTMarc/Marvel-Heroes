//
//  persistencyManager.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
import UIKit
//import Haneke


typealias ImageCacheCompletion = (UIImage) -> Void

/**
 Responsible of managing network and local cache of images and JSON files
 Works together with the parser class to serialize objects from JSON.
 */


class PersistencyManager: NSObject {
    private var _heroes : [Hero] = []
    private var _suggestions : [Hero] = []
    private var _comics : [Comic] = []
    //private let cache = Shared.JSONCache
    private let _parser : Parser
    private let _storageArchitecture : StorageArchitecture
    private let _cache = NSCache<NSString,UIImage>()
    
    //    override init() {
//        super.init()
//        fetchHeroes()
//    }
    
//    class var manager: PersistencyManager {
//        struct manager {
//            static let instance = PersistencyManager(parseType: .functional, storageArchitecture: .other)
//        }
//        return manager.instance
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
    
    func fetchData(_ endPoint: String, parameter: String, offset: Int, notification: Consts.Notifications){
        
        let URL = Foundation.URL(string: Consts.ApiURL.BASE + endPoint + "?" + "\(parameter)" + "offset=\(offset)&" + Consts.ApiURL.CREDENTIALS)!
        //print(URL)
        
        let mySession = URLSession(configuration: URLSessionConfiguration.default)
        let myRequest = URLRequest(url: URL)
        //myRequest.httpMethod = "GET"
        
        
        //let myConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
        let task = mySession.dataTask(with: myRequest){ (data, response, error) in

        
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
                    self._heroes.append(contentsOf: self._parser.parseHeroes("nothing"))
                    
                case .comics:
                    self._comics = self._parser.parseComics()
                    
                case .suggestions:
                    self._suggestions = self._parser.parseHeroes("nothing")
                    
                case .modal_heroDetail_dismissed:
                    break
                    
                } //End of switch
                //We completed our job and can the notification can be sent
                NotificationCenter.default.post(
                    name: Notification.Name(notification.rawValue), object: self)
            
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
        return _heroes
    }
    
    func getHero(id: Int) -> Hero?{
        let hero : [Hero] = _heroes.filter({
            $0.heroId == id
        })
        
        return hero[0]
    }
    
//    func getImage(link: String, completion: ImageCacheCompletion) -> UIImage?{
//        
//        if let image = _cache.object(forKey: link){
//            
//            return image
//        } else {
//            //Download it
//            guard let url = URL(string: link)
//                else { return nil}
//            
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let httpURLResponse = response as? HTTPURLResponse ,
//                    httpURLResponse.statusCode == 200,
//                    let mimeType = response?.mimeType ,
//                    mimeType.hasPrefix("image"),
//                    let data = data ,
//                    error == nil
//                else { return }
//            
//            guard let downloadedImage = UIImage(data: data)
//                else { return }
//            self._cache.setObject(downloadedImage, forKey: link)
//                
//            DispatchQueue.main.async(execute: { () -> Void in
//                completion(downloadedImage)
//            })
//            
//            }
//            task.resume()
//        }
//        return nil
//    }
//    
    func getCache() -> NSCache<NSString,UIImage>{
        return _cache
    }
    
    func getMoreHeroes(_ offset: Int) {
        fetchData(Consts.ApiURL.CHARACTERS, parameter: "", offset: offset, notification: Consts.Notifications.heroes)
    }
    
    //MARK: SUGGESTIONS
    
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
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: Consts.Notifications.suggestions.rawValue), object: self)
    }
    
    //MARK: COMICS
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
     Dummy Heroes creation
     */
    func createSampleData() {
        
        _heroes.append(Hero.init(name: "Batman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: Date(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"))
        
        _heroes.append(Hero.init(name: "Superman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: Date(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/8/03/510c08f345938.jpg"))
    }
    
    
}
