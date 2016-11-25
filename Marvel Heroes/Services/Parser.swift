//
//  Parser.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation

/**
 Parses JSON files
 
 - parameter data: Needs to be initialized with a Dictionary
 */

class Parser: NSObject {
    
    typealias Payload = [String: AnyObject]
    
    // MARK: - Properties
    private var _data : Data?
    private var _dict : NSDictionary?
    private let _parseType : ParseType
    
    // MARK: - Initializers
    init(dict: NSDictionary?, data: Data?, parseType: ParseType) {
        self._dict = dict
        self._data = data
        self._parseType = parseType
    }
    
    convenience init(parseType: ParseType){
        self.init(dict: nil, data:nil, parseType: parseType)
    }
    
    func setData(_ data: Data){
        _data = data
    }
    
    func setDict(_ dict: NSDictionary){
        _dict = dict
    }
    
    //MARK: - Methods
    func parseHeroes(_ type: String) -> [Hero]{
        
        return parseHero()
    }

    func serialize() -> [NSDictionary]? {
        guard let json = try? JSONSerialization.jsonObject(with: _data!, options: .allowFragments)
            else { print("error creating JSON"); return nil } ///-->Exit now if this is not true
        
        guard let rootDict = json as? NSDictionary,
            let dataDict = rootDict["data"] as? Payload,
            let resultsArray = dataDict["results"] as? [NSDictionary]
            else { print("error creating the main Dictionary"); return nil} ///-->Exit now if this is not true
        return resultsArray
    }
    
    func parseHero() -> [Hero]{
        var heroes : [Hero] = []
        
        switch _parseType {
        case .swifty:
            break
            //TODO: - Implement when SwiftyJSON supports Swift3
            
        case .functional:
            guard let resultsArray : [NSDictionary] = serialize()
            else { print("Couldn't serialize and we didn´t even start to create objects"); break }
            heroes = resultsArray.flatMap({
                //(resultsDict: NSDictionary) -> Hero in
                guard let name = $0["name"] as? String,
                    let theId = $0["id"] as? Int,
                    let desc = $0["description"] as? String
                    else { return nil }
                
                guard let thumbnail = $0["thumbnail"] as? [String:String],
                    let fileName = thumbnail["path"],
                    let fileExtension = thumbnail["extension"]
                    else { fatalError("no thumbnail path")  }

                let thumbnailCompletePath : String? = fileName + "." + fileExtension

                return Hero(name: name,heroId: theId,desc: desc,modified: Date(),thumbnailUrl: thumbnailCompletePath ?? "") ///if thumbnail is nil, we change it for ""
            })
            
        }
        return heroes
    }
    
    func parseComics() -> [Comic]{
        var comics : [Comic] = []
        
        switch _parseType {
        case .swifty:
            break
        //TODO: - Implement when SwiftyJSON supports Swift3
        
        case .functional:
            guard let resultsArray : [NSDictionary] = serialize()
                else { print("Couldn't serialize and we didn´t even start to create objects"); break }
            
            comics = resultsArray.flatMap({
                guard let name = $0["title"] as? String,
                    let theId = $0["id"] as? Int
                    else { return nil }
                
                guard let thumbnail = $0["thumbnail"] as? [String:String],
                    let fileName = thumbnail["path"],
                    let fileExtension = thumbnail["extension"]
                    else { fatalError("no thumbnail path")}
                
                let thumbnailCompletePath : String? = fileName + "." + fileExtension
                return  Comic(title: name,comicId: theId, thumbnailUrl: thumbnailCompletePath ?? "") ///if thumbnail is nil, we change it for ""
            })
        }//Switch end
        
        //print(comics)
        return comics
    
    } //Function end
    
} //Class end


