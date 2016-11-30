//
//  ViewControllerTests.swift
//  Marvel Heroes
//
//  Created by Marc Humet Sors on 11/29/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import XCTest

@testable import Marvel_Heroes


class ViewControllerTests: XCTestCase {
    
    var viewController: MasterViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main",
                                      bundle: Bundle.main)
        let navigationController = storyboard.instantiateInitialViewController() as! UINavigationController
        viewController = navigationController.topViewController as! MasterViewController
        
        UIApplication.shared.keyWindow!.rootViewController = viewController
        
        // Test and Load the View at the Same Time!
        XCTAssertNotNil(navigationController.view)
        XCTAssertNotNil(viewController.view)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testTheNumberOfItemsInCollectionView() {
        
        //let spyDelegate = SpyDelegate()
        //viewController.testingDelegate = spyDelegate
        //weak var expectation = self.expectation(description: "SomethingWithDelegate calls the delegate as the result of an async method completion")
        //spyDelegate.asyncExpectation = expectation
        //spyDelegate.updateModel()

            sleep(10)
            print("---------------------------------------------------------")
            print(self.viewController.collection.numberOfItems(inSection: 0))
            XCTAssertGreaterThan(self.viewController.countItems, 2)
        
        
//        waitForExpectations(timeout: 30) { error in
//            if let error = error {
//                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
//            }
//            guard let result = spyDelegate.somethingWithDelegateAsyncResult else {
//                    XCTFail("Expected delegate to be called")
//                    return
//            }
//            print("---------------------------------------------------------")
//            print(self.viewController.collection.numberOfItems(inSection: 0))
//            XCTAssertGreaterThan(self.viewController.countItems, 2)
//            XCTAssertTrue(result)
//            }
    }
}


//TODO: Test Comic Cell loading called testThatWeCanAsyncDownloadImagesInComicCells
//    let cell = ComicCell()
//    let xMen = Comic(title: "All-New X-Men (2012) #31", comicId: 48534, thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/5/60/53f4faa231041.jpg")
//    let model = ComicCellModel(comic: xMen )

