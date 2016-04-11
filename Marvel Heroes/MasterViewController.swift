//
//  MasterViewController.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Alamofire

class MasterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var heroes = [Hero]()
    var filteredHeroes = [Hero]()
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        heroes.append(Hero.init(name: "Batman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: NSDate(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"))
        
        heroes.append(Hero.init(name: "Superman", heroId: 1900, desc: "Lorem fistrum diodenoo", modified: NSDate(), thumbnailUrl: "http://i.annihil.us/u/prod/marvel/i/mg/c/e0/535fecbbb9784.jpg"))
        
        sendRequestforHeroes()
    }
    

    func sendRequestforHeroes() {
        /**
         Characters (Heroes)
         GET http://gateway.marvel.com/v1/public/characters
         */
        
        // Add URL parameters
        let urlParams = [
            "ts":"1",
            "apikey":"c88613ef9c4edc6dee9b496c6f0d0a93",
            "hash":"27861456bf9a405a5e8320359485b698",
            ]
        
        // Fetch Request
        Alamofire.request(.GET, URL_BASE + URL_CHARACTERS, parameters: urlParams)
            .validate(statusCode: 200..<300)
            .responseJSON { response in
                if (response.result.error == nil) {
                    //debugPrint("HTTP Response Body: \(response.result.value)")
                    
                }
                else {
                    //debugPrint("HTTP Request failed: \(response.result.error)")
                }
        }
    }

    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HERO_CELL, forIndexPath: indexPath) as? HeroCell {
            
            let hero: Hero!
            
            if inSearchMode {
                hero = filteredHeroes[indexPath.row]
            } else {
                hero = heroes[indexPath.row]
            }
            
            print(hero.name)

            
            cell.configureCell(hero)
            return cell
            
        } else {
            return UICollectionViewCell()
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let hero: Hero!
        
        if inSearchMode {
            hero = filteredHeroes[indexPath.row]
        } else {
            hero = heroes[indexPath.row]
        }
        
        print(hero.name)
        performSegueWithIdentifier(SEGUE_TO_HERO_DETAIL_VC, sender: hero)
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            return filteredHeroes.count
        }
        
        return heroes.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        view.endEditing(true)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        } else {
            inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredHeroes = heroes.filter({$0.name.lowercaseString.containsString(lower)})
            collection.reloadData()
        }
    }
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_TO_HERO_DETAIL_VC {
            if let detailsVC = segue.destinationViewController as? DetailViewController {
                if let hero = sender as? Hero {
                    detailsVC.hero = hero
                }
            }
        }
    }
}