//
//  Comic.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 12/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation

class Comic {
        
        private var _title: String!
        private var _comicId: Int!
        private var _thumbnailUrl: String!
        
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
    
    extension Comic: CustomStringConvertible {
        var description : String {
            return "\(title) (\(comicId)) {:: \(thumbnailUrl)}"
        }
}


