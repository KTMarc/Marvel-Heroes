//
//  MasterViewController.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

/**
Collection View with Hero objects
 */

class MasterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate {

    //Types
    typealias Model = MasterViewControllerModel
    
    //Properties
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    var searchController: UISearchController!
    

    //private var state = State.viewing
    private var model = Model()
    
    //MARK: Fix or delete
    var filteredHeroes = [Hero]()
    var inSearchMode = false
    var currentOffset = 0
    
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        //searchBar.delegate = self
        //searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.hidden = true
        
        //UI
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "navBarLogo.png")
        imageView.image = image
        navigationItem.titleView = imageView

        
        //Get the model
        apiClient.sharedInstance
        
        configureSearchController()
        listenToNotifications()

    }
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collection.reloadData()
    }
    
    
    //MARK: API request 📡
    func listenToNotifications(){
        NSNotificationCenter.defaultCenter().addObserverForName(NOTIFICATION_HEROES, object: nil, queue: nil) {  (_) in
            
            //FIXME: ARC should do the job here and deallocate all objects from the old struct. This could be better.
            self.model = Model()
            _ = apiClient.sharedInstance.getHeroes().map{self.model.append($0)}
            
            self.collection.reloadData()
            //print("Heros from notification: \(self.model.heroes.count)")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MasterViewController.rotationDetected), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
         NSNotificationCenter.defaultCenter().addObserverForName(NOTIFICATION_MODAL_HERODETAIL_DISMISSED, object: nil, queue: nil) {  (_) in
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    /**
     Adjust Search Bar size when rotating devices
     */
    func rotationDetected(){
        searchController.searchBar.sizeToFit()
    }
    
    // MARK: Search Results Controller 🔍
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: SuggestionsViewController())
        
        searchController.definesPresentationContext = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search more Heroes, i.e. X-Men"
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.sizeToFit()
        collection.superview!.addSubview(searchController.searchBar)
        print(searchController.delegate)
        self.definesPresentationContext = true
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
    }

    
    //MARK: UI Search Controller Delegate
    func didPresentSearchController(searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func willPresentSearchController(searchController: UISearchController) {
        //Tap on the search bar
    }
    
    func didDismissSearchController(searchController: UISearchController) {
        //cancel button press
    }
    
    func willDismissSearchController(searchController: UISearchController) {
        //cancel button press
    }
    
    
    
    //MARK: Search Bar Delegate
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        //view.endEditing(true)
    }
    
    /*
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            inSearchMode = false
            view.endEditing(true)
            collection.reloadData()
        } else {
            //Uncomment to have the local search filter
            //inSearchMode = true
            let lower = searchBar.text!.lowercaseString
            filteredHeroes = model.heroes.filter({$0.name.lowercaseString.containsString(lower)})
            collection.reloadData()
        }
    }*/
    
    // MARK: API request to get suggestions 📡
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let keystrokes = searchController.searchBar.text where keystrokes != "" {
            apiClient.sharedInstance.searchHeroes(keystrokes)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        apiClient.sharedInstance.resetHeroSuggestions()
        collection.reloadData()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        apiClient.sharedInstance.resetHeroSuggestions()
        collection.reloadData()
    }
    
    //MARK: Collection View Data Soure
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HERO_CELL, forIndexPath: indexPath) as? HeroCell {
            let hero: Hero!
            
            //Uncomment to have the local search filter
//            if inSearchMode {
//                hero = filteredHeroes[indexPath.row]
//            } else {
                hero = model.heroes[indexPath.row]
//            }
            
            cell.configureCell(hero)
            
            if (indexPath.item == model.heroes.count - 1) && (model.heroes.count > currentOffset){
                print("fetching more stuff")
                currentOffset += 20
                apiClient.sharedInstance.moreHeroes(currentOffset)
            }
            cell.fadeIn()
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if inSearchMode {
            //Uncomment to have the local search filter
            // return filteredmodel.model.heroes.count
        }
        
        return model.heroes.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return CGSizeMake(105, 105)
    }

    
    //MARK: Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
//        let hero: Hero!
//        
//        if inSearchMode {
//            hero = filteredHeroes[indexPath.row]
//        } else {
//            hero = heroes[indexPath.row]
//        }
    
        performSegueWithIdentifier(SEGUE_TO_HERO_DETAIL_VC, sender: nil)
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == SEGUE_TO_HERO_DETAIL_VC {
            if let detailsVC = segue.destinationViewController as? HeroDetailVC {
                if let selectedHeroIndex = collection.indexPathsForSelectedItems() where selectedHeroIndex.count == 1{
                    let hero = model.heroes[selectedHeroIndex[0].row]
                detailsVC.hero = hero
                }

            }
        }
    }
}