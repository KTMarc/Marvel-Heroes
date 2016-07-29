//
//  Parser.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
import SwiftyJSON

/**
 Parses JSON files
 
 - parameter data: Needs to be initialized with a Dictionary
 */

class Parser: NSObject {

    // MARK: Types
    enum ParseType {
        case swifty
        case functional
    }
    
    typealias Payload = [String: AnyObject]
    
    // MARK: Properties
    private var _data : NSData?
    private var _dict : NSDictionary?
    private let _parseType : ParseType
    
    // MARK: Initializers
    init(dict: NSDictionary?, data: NSData?, parseType: ParseType) {
        self._dict = dict
        self._data = data
        self._parseType = parseType
    }
    
    convenience init(parseType: ParseType){
        self.init(dict: nil, data:nil, parseType: .swifty)
    }
    
    func setData(data: NSData){
        _data = data
    }
    
    func setDict(dict: NSDictionary){
        _dict = dict
    }
    
    //MARK: Methods
    func parseHeroes(type: String) -> [Hero]{
        
        return parseHero()
    }

    func parseHero() -> [Hero]{
        var heroes : [Hero] = []
        
        switch _parseType {
        case .swifty:
            
            let json = JSON(_dict!)
            if let results = json["data"]["results"].array {
                //print("Received \(results.count) elements\n")
                for (_,subJson):(String, JSON) in JSON(results) {
                    ///print(subJson["name"].string)
                    if let theId = subJson["id"].int {
                        if let theName = subJson["name"].string {
                            if let theDescription = subJson["description"].string{ //This is never nil, returns "" if no description
                                if let theThumbnail = subJson["thumbnail"].dictionary{
                                    let thumbnailCompletePath : String = (theThumbnail["path"]?.string)! + "." + (theThumbnail["extension"]?.string)!
                                    
                                    heroes.append(Hero(
                                        name: theName,
                                        heroId: theId,
                                        desc: theDescription,
                                        modified:NSDate(),
                                        thumbnailUrl: thumbnailCompletePath))
                                } else { print("Thumbnail of \(theName) was nil")}
                            }else{ print("Description of \(theName) was nil")}
                        }
                    }
                    
                }
                //print(heroes)
            }
            
        case .functional:
            
            guard let json = try? NSJSONSerialization.JSONObjectWithData(_data!, options: .AllowFragments)
                else { print("error creating JSON"); break } ///-->Exit now if this is not true
            
            guard let rootDict = json as? NSDictionary,
                let dataDict = rootDict["data"] as? Payload,
                let resultsArray = dataDict["results"] as? Array<NSDictionary>
                else { print("error creating the main Dictionary"); break } ///-->Exit now if this is not true
            
            heroes = resultsArray.flatMap({
                //(resultsDict: NSDictionary) -> Hero in
                guard let name = $0["name"] as? String,
                    let heroId = $0["id"] as? Int,
                    let desc = $0["description"] as? String
                    else { return nil }
                
                guard let thumbnail = $0["thumbnail"] as? [String:String],
                    let fileName = thumbnail["path"],
                    let fileExtension = thumbnail["extension"],
                    let thumbnailCompletePath : String = fileName + "." + fileExtension
                    else { fatalError("no thumbnail path")  }
                
                return Hero(name: name,heroId: heroId,desc: desc,modified: NSDate(),thumbnailUrl: thumbnailCompletePath ?? "") ///if thumbnail is nil, we change it for ""
            })
            
        }
        return heroes
    }
    
    func parseComics() -> [Comic]{
        var comics : [Comic] = []
        let json = JSON(_dict!)
        if let results = json["data"]["results"].array {
            print("Received \(results.count) comics\n")
            for (_,subJson):(String, JSON) in JSON(results) {
                //print(subJson["title"].string)
                if let theId = subJson["id"].int {
                    if let theTitle = subJson["title"].string {
                            if let theThumbnail = subJson["thumbnail"].dictionary{
                                let thumbnailCompletePath : String = (theThumbnail["path"]?.string)! + "." + (theThumbnail["extension"]?.string)!
                                
                                comics.append(Comic(
                                    title: theTitle,
                                    comicId: theId,
                                    thumbnailUrl: thumbnailCompletePath))
                                //print(comics.count)
                        }
                    }
                }
            }
        }
        //print(comics)
        return comics
    }
}


