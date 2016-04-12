//
//  Marvel_HeroesTests.swift
//  Marvel HeroesTests
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import XCTest
import Haneke

@testable import Marvel_Heroes

class Marvel_HeroesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        apiClient.sharedInstance

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
    }
    
    func testCharactersParsing() {
        var heroes = [Hero]()
    
        
//        let bundle = NSBundle(forClass: self.dynamicType)
//        if let path = bundle.pathForResource("listCharacters", ofType: "json"){
            
            //let jsonData = NSData(contentsOfFile: path!)
//            if let URL = NSURL.fileURLWithPath(path) {
//                print("We found the file")
//                let cache = Shared.JSONCache
//            
//                cache.fetch(URL: URL).onSuccess { JSON in
//                heroes = parser(data: JSON.dictionary).parseJSON(URL_CHARACTERS)
//                }
//            }
//        }
        XCTAssertEqual(heroes.count, 0)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
