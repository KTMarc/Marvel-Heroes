//
//  Constants.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation

/**
 GET http://gateway.marvel.com/v1/public/characters
 
 - parameter ts: TimeStamp
 - parameter apikey: Your public Key
 - parameter Hash: MD5 (ts + privateKey + publicKey)
 */

struct Consts {
    static let urlParams = [
        "ts":"1",
        "apikey":"c88613ef9c4edc6dee9b496c6f0d0a93",
        "hash":"27861456bf9a405a5e8320359485b698",
        ]
    
    //API parameters
    struct ApiURL {
        static let BASE = "http://gateway.marvel.com/v1/public/"
        static let CHARACTERS = "characters"
        static let COMICS = "comics"
        static let CREDENTIALS = "ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698"
    }
    
    //SEGUES
    struct Segues {
        //Heroes Master View Controller
        static let TO_HERO_DETAIL_VC = "DetailViewController"
    }
    
    //STORYBOARD IDs
    struct StoryboardIds {
        
        static let HERO_DETAIL_VC = "HeroDetailVC"
        //Heroes Master View Controller
        static let HERO_CELL = "HeroCell"
        
        //Suggestions table view Controller
        static let SUGGESTION_CELL = "SuggestionCell"
        
        //Hero Detail View Controller
        static let COMIC_CELL = "ComicCell"
    }
    
    //COPY
    struct Copies {
        static let NO_DESCRIPTION_AVAILABLE_COPY = "No description available, please check out the wiki"
    }
    
    //NOTIFICATIONS
    enum Notifications: String {
        case heroes = "heroesDownloadedNotification"
        case comics = "comicsDownloadedNotification"
        case suggestions = "suggestionsDownloadedNotification"
        case modal_heroDetail_dismissed = "heroDetailVCWasDismissed"
    }
    
}