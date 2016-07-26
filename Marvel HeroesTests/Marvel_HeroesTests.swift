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
    
    /**
 Haneke will first attempt to fetch the required JSON from (in order) memory, disk or NSURLCache. 
     
     If not available, Haneke will fetch the JSON from the source, return it and then cache it. In this case, the URL itself is used as the key
 
     local path would be loaded like path = NSBundle(forClass: self.dynamicType).pathForResource("listCharacters", ofType: "json")
 */
    
    func testCharactersJSONFileIsDownloadedAndParsed() {
        var heroes = [Hero]()
        let expectation = expectationWithDescription("Download, Parse and create objects")
        
        apiClient.sharedInstance.fetchHeroes()

        NSNotificationCenter.defaultCenter().addObserverForName(Consts.Notifications.heroes.rawValue, object: nil, queue: nil) {  (_) in
            
            heroes = apiClient.sharedInstance.getHeroes()
            expectation.fulfill()
        }
        
        waitForExpectationsWithTimeout(5, handler: nil)
        XCTAssertGreaterThan(heroes.count, 0)
    }
    
    
    func testThatWeCanFindSpiderMan() {
        
        //3D Man
        let partOfHeroName = "Spider"
        var heroes = [Hero]()
        
        apiClient.sharedInstance.searchHeroes(partOfHeroName)
        
        let expectation = expectationWithDescription("Find Spider-Man")
        
        NSNotificationCenter.defaultCenter().addObserverForName(Consts.Notifications.suggestions.rawValue, object: nil, queue: nil) {  (_) in
            
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

        NSNotificationCenter.defaultCenter().addObserverForName(Consts.Notifications.comics.rawValue, object: nil, queue: nil) {  (_) in
            
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
    

