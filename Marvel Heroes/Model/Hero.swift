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

struct Hero: Equatable{

    private var _name: String = ""
    private var _heroId: Int = 0
    private var _desc: String = ""
    private var _modified: Date = Date()
    private var _thumbnailUrl: String = ""
    
    init(){}
    
    init(name: String, heroId: Int, desc: String?, modified: Date , thumbnailUrl: String) {
        self._name = name
        self._heroId = heroId
        
        if let x = desc , x == ""{
            self._desc = Consts.Copies.NO_DESCRIPTION_AVAILABLE_COPY
        } else if desc != nil {
            self._desc = desc!
        } else {
            self._desc = Consts.Copies.NO_DESCRIPTION_AVAILABLE_COPY
        }
        
        self._modified = modified
        self._thumbnailUrl = thumbnailUrl
    }
    
    //Convenience init for tests
    init(heroId: Int){
        self._name = ""
        self._heroId = heroId
        self._desc = ""
        self._modified = Date()
        self._thumbnailUrl = ""
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
    
    var modified: Date {
        return _modified
    }
    
    var thumbnailUrl: String {
        return _thumbnailUrl
    }
}


//MARK: Protocols and extensions
func ==(lhs: Hero, rhs: Hero) -> Bool {
    return  lhs.name == rhs.name &&
        lhs.heroId == rhs.heroId &&
        lhs.desc == rhs.desc &&
        lhs.thumbnailUrl == rhs.thumbnailUrl
}

extension Hero: CustomStringConvertible {
    var description : String {
        return "\(name) (\(heroId)) {\(desc) :: \(thumbnailUrl)}"
    }
}
