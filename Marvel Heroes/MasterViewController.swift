//
//  MasterViewController.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Alamofire
import Haneke

class MasterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var heroes = [Hero]()
    var filteredHeroes = [Hero]()
    var inSearchMode = false
    var currentOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.Done
        
        //Get the model
        apiClient.sharedInstance
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MasterViewController.heroesReady), name: "heroesDownloadedNotification", object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func heroesReady(){
        heroes = apiClient.sharedInstance.getHeroes()
        self.collection.reloadData()
        print("Heroes in notification")
        print(self.heroes.count)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HERO_CELL, forIndexPath: indexPath) as? HeroCell {
            
            let hero: Hero!
            
            if inSearchMode {
                hero = filteredHeroes[indexPath.row]
            } else {
                hero = heroes[indexPath.row]
            }
            
            cell.configureCell(hero)
//            cell.thumbImg.layer.borderWidth = 1
//            cell.thumbImg.layer.masksToBounds = false
//            cell.thumbImg.layer.borderColor = UIColor.whiteColor().CGColor
//            cell.thumbImg.layer.cornerRadius = cell.thumbImg.frame.height / 2
//            cell.thumbImg.clipsToBounds = true
            
            if (indexPath.row == heroes.count - 1) && (heroes.count < currentOffset){
//                print("fetching more stuff")
//                currentOffset += 20
//                apiClient.sharedInstance.moreHeroes()
            }
            
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
        
        //print(hero.name)
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