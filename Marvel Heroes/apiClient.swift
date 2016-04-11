//
//  apiClient.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 11/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import Foundation
import Alamofire

class apiClient: NSObject {
    
private let persistencyManager: PersistencyManager
private let isOnline: Bool
private let urlParams = [
        "ts":"1",
        "apikey":"c88613ef9c4edc6dee9b496c6f0d0a93",
        "hash":"27861456bf9a405a5e8320359485b698",
        ]

    class var sharedInstance: apiClient {
        struct Singleton {
            static let instance = apiClient()
        }
        return Singleton.instance
    }

    override init() {
        persistencyManager = PersistencyManager()
        isOnline = false
        super.init()
    }
    
    func getHeroes() -> [Hero] {
        return persistencyManager.getHeroes()
    }
    
    /**
     GET http://gateway.marvel.com/v1/public/characters
     
     - parameter ts: TimeStamp
     - parameter apikey: Your public Key
     - parameter Hash: MD5 (ts + privateKey + publicKey)
     
     */
    
    func fetchHeroes() {
        
        //Fetch Request
        Alamofire.request(.GET, URL_BASE + URL_CHARACTERS, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    //debugPrint("HTTP Response Body: \(response.result.value)")
                    let heroes : [Hero] = []
                    
                    self.persistencyManager.saveHeroes(heroes)
                }
                else {
                    //debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }
    
    
    
    
    
    





}
