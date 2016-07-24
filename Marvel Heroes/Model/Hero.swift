//
//  Hero.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation

/**
 Holds Character entity information. Called hero for simplicity
 */

class Hero /*:Hashable*/{

    private var _name: String
    private var _heroId: Int
    private var _desc: String
    private var _modified: NSDate
    private var _thumbnailUrl: String
    
    
//    internal var hashValue: Int {
//        return self.name.hashValue
//    }
    
    init(name: String, heroId: Int, desc: String?, modified: NSDate , thumbnailUrl: String) {
        self._name = name
        self._heroId = heroId
        
        if let x = desc where x == ""{
            self._desc = NO_DESCRIPTION_AVAILABLE_COPY
        } else {
            self._desc = desc!
        }
        
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
        return _desc
    }
    
    var thumbnailUrl: String {
        return _thumbnailUrl
    }
}

//MARK: Protocols
//func ==(lhs: Hero, rhs: Hero) -> Bool {
//    return lhs.hashValue == rhs.hashValue
//}

extension Hero: CustomStringConvertible {
    var description : String {
        return "\(name) (\(heroId)) {\(desc) :: \(thumbnailUrl)}"
    }
}


