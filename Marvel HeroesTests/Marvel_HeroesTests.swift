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
        _ = apiClient.singleton
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        NotificationCenter.default.removeObserver(self)
    }
    
    /**
     Haneke will first attempt to fetch the required JSON from (in order) memory, disk or NSURLCache.
     
     If not available, Haneke will fetch the JSON from the source, return it and then cache it. In this case, the URL itself is used as the key
 
     local path would be loaded like path = NSBundle(forClass: self.dynamicType).pathForResource("listCharacters", ofType: "json")
     */
    
    func testThatWeCanParseLocalJSONfile(){
        
        var heroes = [Hero]()

        
        ///Data: NSData
        ///Response: 200,400,etc..
        ///Error
    
        //let path = NSBundle.mainBundle().pathForResource("listCharacters",ofType:"json") --> Doesn´t work in Tests
        //let responsePath = NSBundle(forClass: Marvel_HeroesTests.self).pathForResource("listCharacters_response", ofType: "txt")

        //let response = NSURLResponse(URL: NSURL(fileURLWithPath: responsePath!), MIMEType: nil, expectedContentLength: -1, textEncodingName: nil)
        
        //let puta = NSHTTPURLResponse(URL: NSURL(fileURLWithPath: responsePath!), MIMEType: nil, expectedContentLength: -1, textEncodingName: nil)
        //        //if let httpResponse = response as? NSHTTPURLResponse {
        //            print(puta.statusCode)
        //        //}
    
        let path = Bundle(for: Marvel_HeroesTests.self).path(forResource: "listCharacters", ofType: "json")
        
        if let data = try? Data(contentsOf: URL(fileURLWithPath: path!)){
        
        //This should not be tested directly instantiating the parser
        let parser = Parser(dict: nil, data: data, parseType: .functional)
        ///call the parser
        
        heroes = parser.parseHeroes("kk")
        XCTAssertEqual(heroes.count, 20)
        }
    }
    
    
    func testCharactersJSONFileIsDownloadedAndParsed() {
        weak var expectation = self.expectation(description: "Download, Parse and create objects")
        var heroes = [Hero]()

        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.heroes.rawValue), object: nil, queue: nil) {  (_) in
            
            heroes = apiClient.singleton.getHeroes()
            expectation?.fulfill()
        }
        
        apiClient.singleton.fetchHeroes()
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertGreaterThan(heroes.count, 0)
    }
    
    
    func testThatWeCanFindSpiderMan() {
        
        //3D Man
        let partOfHeroName = "Spider"
        var heroes = [Hero]()
        
        apiClient.singleton.searchHeroes(partOfHeroName)
        
        weak var expectation = self.expectation(description: "Find Spider-Man")
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.suggestions.rawValue), object: nil, queue: nil) {  (_) in
            
            heroes = apiClient.singleton.getHeroes()
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
            
            comics = apiClient.singleton.getComics()
            expectation?.fulfill()
        }
        
        apiClient.singleton.fetchComics(heroId)
        
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(comics.count, 11)
    }
    
    func downloadOrNot( downloadCount: Int, cache: NSCache<AnyObject, AnyObject>, hero: Hero) -> Int{
        
        var imageView : UIImageView
        if let image = cache.object(forKey: hero.thumbnailUrl) as? UIImage{
            imageView = UIImageView(image: image)
        } else {
            //Download the fucking image
            imageView = UIImageView(image: UIImage(contentsOfFile: "navBarLogo.png"))
            
            imageView.downloadAsyncFrom(hero.thumbnailUrl, contentMode: .scaleAspectFill){
                cache.setObject(imageView.image!, forKey: hero.thumbnailUrl)
     //           return ((Int)downloadCount + 1)
            }
        }
        return downloadCount
    }
    
//    func testThatWeCanCacheImages(){
//        
//        let imgCache = NSCache<AnyObject,AnyObject> ()
//        let hero = apiClient.singleton.getHero(id: 1011334)
//
//        var downloadCount = 0
//        
//        downloadCount = downloadOrNot(downloadCount: downloadCount, cache: imgCache, hero: hero)
//        
//        XCTAssertEqual(downloadCount,1)
//        
//    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
    

