//
//  Marvel_HeroesTests.swift
//  Marvel HeroesTests
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import XCTest
//import Haneke

@testable import Marvel_Heroes

class Marvel_HeroesTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        _ = apiClient.manager
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThatWeCanParseLocalJSONfile(){
        
        var heroes = [Hero]()
        let idealHero = Hero(name: "3-D Man", heroId: 1011334, desc: Consts.Copies.NO_DESCRIPTION_AVAILABLE_COPY, modified: Date.init(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg")
        
        let path = Bundle(for: Marvel_HeroesTests.self).path(forResource: "listCharacters", ofType: "json")
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path!)){
        
        //This should not be tested directly instantiating the parser
        let parser = Parser(data: data, parseType: .functional)
        ///call the parser
        
        heroes = parser.parseHeroes()
        XCTAssertEqual(heroes.count, 20)
        XCTAssertEqual(heroes[0], idealHero)
        }
    }
    
    
    func testCharactersJSONFileIsDownloadedAndParsed() {
        weak var expectation = self.expectation(description: "Download, Parse and create objects")
        var heroes = [Hero]()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.heroes.rawValue), object: nil, queue: nil) {  (_) in
            
            heroes = apiClient.manager.getHeroes()
            expectation?.fulfill()
        }
        
        apiClient.manager.fetchHeroes()
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertGreaterThan(heroes.count, 0)
    }
    
    func testThatWeCanFindSpiderMan() {
        
        //3D Man
        let partOfHeroName = "Spider"
        var heroes = [Hero]()
        
        apiClient.manager.searchHeroes(partOfHeroName)
        
        weak var expectation = self.expectation(description: "Find Spider-Man")
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.suggestions.rawValue), object: nil, queue: nil) {  (_) in
            
            heroes = apiClient.manager.getHeroes()
            expectation?.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertGreaterThan(heroes.count, 1)
    }
    

    func testThat3DManHas11Comics() {
        
        //3D Man
        let heroId = 1011334
        var comics = [Comic]()
        
        weak var expectation = self.expectation(description: "Receive comics")

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.comics.rawValue), object: nil, queue: nil) {  (_) in
            
            comics = apiClient.manager.getComics()
            expectation?.fulfill()
        }
        
        apiClient.manager.fetchComics(heroId)
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(comics.count, 11)
    }
    
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
    

