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

let urlParams = [
    "ts":"1",
    "apikey":"c88613ef9c4edc6dee9b496c6f0d0a93",
    "hash":"27861456bf9a405a5e8320359485b698",
]

//API parameters
let URL_BASE = "http://gateway.marvel.com/v1/public/"
let URL_CHARACTERS = "characters"
let URL_COMICS = "comics"
let URL_CREDENTIALS = "ts=1&apikey=c88613ef9c4edc6dee9b496c6f0d0a93&hash=27861456bf9a405a5e8320359485b698"

//Heroes Master View Controller
let HERO_CELL = "HeroCell"
let SEGUE_TO_HERO_DETAIL_VC = "DetailViewController"

//Suggestions table view Controller
let SUGGESTION_CELL = "suggestionCell"

//Hero Detail View Controller
let COMIC_CELL = "ComicCell"
let NO_DESCRIPTION_AVAILABLE_COPY = "No description available, please check out the wiki"

//Notifications
let NOTIFICATION_HEROES = "heroesDownloadedNotification"
let NOTIFICATION_COMICS = "comicsDownloadedNotification"
let NOTIFICATION_SUGGESTIONS = "suggestionsDownloadedNotification"
let NOTIFICATION_MODAL_HERODETAIL_DISMISSED = "heroDetailVCWasDismissed"