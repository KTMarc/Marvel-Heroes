//
//  MasterViewControllerModel.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 24/7/16.
//  Copyright © 2016 SPM. All rights reserved.
//

struct MasterViewControllerModel{
    
    // MARK: Properties
    
    private var _heroes: [Hero]
    var heroes: [Hero] { return _heroes }
    
    // MARK: Initialization
    
    init() {
        _heroes = [Hero]()
    }
    
    // MARK: Entry Points to Modify / Query Underlying Model
    
    mutating func append(hero: Hero) {
        _heroes.append(hero)
    }
    
    mutating func removeLast() -> Hero {
        return _heroes.removeLast()
    }
    
    subscript(HeroAt index: Int) -> Hero {
        get {
            return _heroes[index]
        }
        
        set {
            _heroes[index] = newValue
        }
    }
}