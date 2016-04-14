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
        NSNotificationCenter.defaultCenter().removeObserver(self)

        
    }
    
    func testCharactersParsing() {
        let heroes = [Hero]()
    
        if let path = NSBundle.mainBundle().pathForResource("stationList", ofType: "json") {
            if let data = NSData(contentsOfFile: path) {
                        let json = JSON(data: data, options: NSJSONReadingOptions.AllowFragments, error: nil)
        
                        for dict in json.arrayValue {
        let bundle = NSBundle(forClass: self.dynamicType)
        if let path = bundle.pathForResource("listCharacters", ofType: "json"){
            
            let jsonData = NSData(contentsOfFile: path!)
            if let URL = NSURL.fileURLWithPath(path) {
                print("We found the file")
                let cache = Shared.JSONCache
            
                cache.fetch(URL: URL).onSuccess { JSON in
                heroes = parser(data: JSON.dictionary).parseJSON(URL_CHARACTERS)
                }
            }
        }
        XCTAssertEqual(heroes.count, 0)
    }
                        
    func testThatWeCanFindSpiderMan() {
        
        //3D Man
        let partOfHeroName = "Spider"
        var heroes = [Hero]()
        
        apiClient.sharedInstance.searchHeroes(partOfHeroName)
        
        let expectation = expectationWithDescription("Find Spider-Man")
        
        NSNotificationCenter.defaultCenter().addObserverForName(NOTIFICATION_SUGGESTIONS, object: nil, queue: nil) {  (_) in
            
            heroes = apiClient.sharedInstance.getHeroes()
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssertGreaterThan(heroes.count, 1)
        
    }
    

    func testThat3DManHas11Comics() {
        
        //3D Man
        let heroId = 1011334
        var comics = [Comic]()
        
        apiClient.sharedInstance.fetchComics(heroId)
    
        let expectation = expectationWithDescription("Receive comics")

        NSNotificationCenter.defaultCenter().addObserverForName(NOTIFICATION_COMICS, object: nil, queue: nil) {  (_) in
            
            comics = apiClient.sharedInstance.getComics()
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssertEqual(comics.count, 11)
        
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
