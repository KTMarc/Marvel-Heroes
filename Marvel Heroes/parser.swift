//
//  parser.swift
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

class parser: NSObject {

    private let _data : NSDictionary
    
    init(data: NSDictionary) {
        self._data = data
    }
    
    convenience override init(){
        self.init(data: [:])
    }
    
    func parseJSON(type: String) -> [Hero]{
        
        return parseHero()
    }

    func parseHero() -> [Hero]{
        var heroes : [Hero] = []
        let json = JSON(_data)
        if let results = json["data"]["results"].array {
            //print("Received \(results.count) elements\n")
            for (_,subJson):(String, JSON) in JSON(results) {
                ///print(subJson["name"].string)
                if let theId = subJson["id"].int {
                    if let theName = subJson["name"].string {
                        if let theDescription = subJson["description"].string{
                            if let theThumbnail = subJson["thumbnail"].dictionary{
                                let thumbnailCompletePath : String = (theThumbnail["path"]?.string)! + "." + (theThumbnail["extension"]?.string)!
                                
                                heroes.append(Hero(
                                    name: theName,
                                    heroId: theId,
                                    desc: theDescription,
                                    modified:NSDate(),
                                    thumbnailUrl: thumbnailCompletePath))
                            }
                        }
                    }
                }
            }
            //print(heroes)
        }
        return heroes
    }
    
    func parseComics() -> [Comic]{
        var comics : [Comic] = []
        let json = JSON(_data)
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
    
    
    //    func parseJSON(type: String) -> [AnyObject]{
    //        var anyThing : AnyObject?
    //        switch(type){
    //            case URL_CHARACTERS:
    //            anyThing = parseHero()
    //            break
    //
    //        case URL_COMICS:
    //            anyThing = parseComics()
    //            break
    //
    //        default:
    //            break
    //        }
    //        
    //        return [anyThing!]
    //    }

    
}


