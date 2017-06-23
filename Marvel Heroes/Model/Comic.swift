//
//  Comic.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 12/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation

/**
 Holds Comic entity information.
 */

struct Comic: Equatable {
        
        private var _title: String = ""
        private var _comicId: Int = 0
        private var _thumbnailUrl: String = ""
    
        init(){}
    
        init(title: String, comicId: Int, thumbnailUrl: String) {
            self._title = title
            self._comicId = comicId
            self._thumbnailUrl = thumbnailUrl
        }
        
        var title: String {
            return _title
        }
        
        var comicId: Int {
            return _comicId
        }
        
        var thumbnailUrl: String {
            return _thumbnailUrl
        }
    }
    
//MARK: Protocols and extensions

func ==(lhs: Comic, rhs: Comic) -> Bool {
    return  lhs.title == rhs.title &&
        lhs.comicId == rhs.comicId &&
        lhs.thumbnailUrl == rhs.thumbnailUrl
}

extension Comic: CustomStringConvertible {
    var description : String {
        return "\(title) (\(comicId)) {:: \(thumbnailUrl)}"
    }
}

