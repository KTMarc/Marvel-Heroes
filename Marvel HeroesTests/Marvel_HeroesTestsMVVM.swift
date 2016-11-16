//
//  Marvel_HeroesTestsMVVM.swift
//  Marvel Heroes
//
//  Created by Marc Humet Sors on 10/13/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import XCTest

@testable import Marvel_Heroes


///Inspired by:
//http://www.mokacoding.com/blog/testing-delegates-in-swift-with-xctest/

class Marvel_HeroesTestsMVVM: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testThat3DManHas11ComicsMVVM() {
        
        //3D Man
        let heroId = 1011334
        let hero = Hero(heroId: heroId)
        let spyDelegate = SpyDelegate()
        let model = HeroDetailModel(hero: hero, theDelegate: spyDelegate)
        weak var expectation = self.expectation(description: "SomethingWithDelegate calls the delegate as the result of an async method completion")
        spyDelegate.asyncExpectation = expectation
        model.tearUp()
        //spyDelegate.updateModel()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard let result = spyDelegate.somethingWithDelegateAsyncResult else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertEqual(model.comics.count, 11)
            XCTAssertTrue(result)
        }
    }
    
    func testThatWeCanFindGideonMVVM() {
        
        //Giden
        //let heroId = 1011055
        let spyDelegate = SpyDelegate()
        let model = SuggestionsModel(theDelegate: spyDelegate)
        model.search(keystrokes: "Gideon")
        weak var expectation = self.expectation(description: "SomethingWithDelegate calls the delegate as the result of an async method completion")
        spyDelegate.asyncExpectation = expectation
        model.tearUp()
        //spyDelegate.updateModel()
        
        waitForExpectations(timeout: 5) { error in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
            
            guard let result = spyDelegate.somethingWithDelegateAsyncResult else {
                XCTFail("Expected delegate to be called")
                return
            }
            XCTAssertEqual(model.count, 1)
            XCTAssertTrue(result)
        }
    }
}
