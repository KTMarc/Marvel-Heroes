//
//  Hero.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
//import Argo

class Hero {

    private var _name: String!
    private var _heroId: Int!
    private var _desc: String!
    private var _modified: NSDate!
    private var _thumbnailUrl: String!
    
    init(name: String, heroId: Int, desc: String, modified: NSDate , thumbnailUrl: String) {
        self._name = name
        self._heroId = heroId
        self._desc = desc
        self._modified = modified
        self._thumbnailUrl = thumbnailUrl
    }
    
    var name: String {
        return _name
    }
    
    var heroId: Int {
        return _heroId
    }
    
    var desc: String {
        if _desc != nil{
            return _desc
        }else{
            return "Not description available"
        }
    }
    
    var thumbnailUrl: String {
        return _thumbnailUrl
    }
    
}

extension Hero: CustomStringConvertible {
    var description : String {
        return "\(name) (\(heroId)) {\(desc) :: \(thumbnailUrl)}"
    }
}


//extension NSURL: JSONDecodable {
//    public class func decode(j: JSON) -> NSURL? {
//        switch j {
//        case .String(let s):
//            return NSURL(string: s)
//        default:
//            return nil
//        }
//    }
//}
//
//extension Hero: JSONDecodable {
//    static func create(name: String, heroId: Int, desc: String, modified: NSDate, thumbnailUrl: String) -> Hero {
//        return Hero(create(name:name, heroId: heroId, desc: desc, modified: modified, thumbnailUrl: thumbnailUrl)
//    }
//    
//    static func decode(j: JSON) -> Hero? {
//        return Hero.create
//            <^> j <|  "id"
//            <*> j <|  "name"
//            <*> j <|? "description"
//            <*> j <|  "url"
//            <*> j <|? "homepage"
//            <*> j <|  "fork"
//    }
//}
