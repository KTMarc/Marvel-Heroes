//
//  SpyDelegate.swift
//  Marvel Heroes
//
//  Created by Marc Humet Sors on 10/13/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import XCTest

@testable import Marvel_Heroes

class SpyDelegate: ModelUpdaterDelegate {
    
    // Setting .None is unnecessary, but helps with clarity imho
    var somethingWithDelegateAsyncResult: Bool? = .none
    
    // Async test code needs to fulfill the XCTestExpecation used for the test
    // when all the async operations have been completed. For this reason we need
    // to store a reference to the expectation
    var asyncExpectation: XCTestExpectation?
    
    func updateModel() {
        guard let expectation = asyncExpectation else {
            XCTFail("SpyDelegate was not setup correctly. Missing XCTExpectation reference")
            return
        }
        
        somethingWithDelegateAsyncResult = true
        expectation.fulfill()
    }
}
