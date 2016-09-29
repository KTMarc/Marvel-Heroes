//
//  MasterViewController.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 10/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

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
    var currentOffset = 0

    //private var state = State.viewing
    private var model = Model()
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collection.delegate = self
        collection.dataSource = self
        //searchBar.delegate = self
        //searchBar.returnKeyType = UIReturnKeyType.Done
        searchBar.isHidden = true
        
        //UI
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "navBarLogo.png")
        imageView.image = image
        navigationItem.titleView = imageView

        /// On init of apiClient we also init the persistencyManager and start fetching heroes
        
        //apiClient.singleton
        //apiClient.fetchHeroes()
        
        listenToNotifications()
        
        apiClient.singleton.fetchHeroes()
        
        configureSearchController()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collection.reloadData()
    }
    
    
    //MARK: API request 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.heroes.rawValue), object: nil, queue: nil) {  (_) in
            
            //FIXME: ARC should do the job here and deallocate all objects from the old struct. This could be better.
            self.model = Model()
            _ = apiClient.singleton.getHeroes().map{
                self.model.append($0)
            }
            
            DispatchQueue.main.async(execute: {
                self.collection.reloadData()
            })
            
            //print("Heroes from notification: \(self.model.heroes.count)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.rotationDetected), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        NotificationCenter.default.addObserver(
         forName: NSNotification.Name(rawValue: Consts.Notifications.modal_heroDetail_dismissed.rawValue), object: nil, queue: nil) {  (_) in
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
    func didPresentSearchController(_ searchController: UISearchController) {
        searchController.searchBar.becomeFirstResponder()
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //Tap on the search bar
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        //cancel button press
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        //cancel button press
    }
    
    
    //MARK: Search Bar Delegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //view.endEditing(true)
    }
    
    // MARK: API request to get suggestions 📡
    func updateSearchResults(for searchController: UISearchController) {
        if let keystrokes = searchController.searchBar.text , keystrokes != "" {
            apiClient.singleton.searchHeroes(keystrokes)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        apiClient.singleton.resetHeroSuggestions()
        collection.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        apiClient.singleton.resetHeroSuggestions()
        collection.reloadData()
    }
    
    //MARK: Collection View Data Soure
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.StoryboardIds.HERO_CELL, for: indexPath) as? HeroCell {
        
            model.indexPath = indexPath.row
            cell.configureCell(model)
            
            if ((indexPath as NSIndexPath).item == model.heroes.count - 1) && (model.heroes.count > currentOffset){
                print("fetching more stuff")
                currentOffset += 20
                apiClient.singleton.moreHeroes(currentOffset)
            }
            cell.fadeIn()
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.heroes.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 105, height: 105)
    }

    
    //MARK: Collection View Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Consts.Segues.TO_HERO_DETAIL_VC, sender: nil)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Consts.Segues.TO_HERO_DETAIL_VC {
            if let detailsVC = segue.destination as? HeroDetailVC {
                if let selectedHeroIndex = collection.indexPathsForSelectedItems , selectedHeroIndex.count == 1{
                    let selectedHeroIndex = (selectedHeroIndex[0] as NSIndexPath).row
                    let hero = model[heroAt: selectedHeroIndex]
                    detailsVC.setHero(hero)
                }

            }
        }
    }
}
