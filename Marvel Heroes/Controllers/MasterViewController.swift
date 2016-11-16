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


class MasterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate, UISearchResultsUpdating, UISearchControllerDelegate, ModelUpdaterDelegate {

    //MARK: Types
    typealias Model = MasterViewControllerModel
    
    //MARK: Outlets
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    //TODO: find a nicer way to create an horizontal line
    //MARK:
    //MARK: Properties
    var searchController: UISearchController!
    var _currentOffset = 0

    private var _model = Model()
    private var _searchTimer: Timer?
    private var _keystrokes = ""
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Initialization
        _model = Model(theDelegate: self)
        _model.tearUp()
        configureSearchController()
        listenToNotifications()
        collection.delegate = self
        collection.dataSource = self
        //TODO: Could be deleted, check it
        searchBar.isHidden = true
        
        //UI
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "navBarLogo.png")
        navigationItem.titleView = imageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collection.reloadData()
    }
    
    //MARK: Notifications 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(MasterViewController.rotationDetected), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        NotificationCenter.default.addObserver(
         forName: NSNotification.Name(rawValue: Consts.Notifications.modal_heroDetail_dismissed.rawValue), object: nil, queue: nil) {  (_) in
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    //MARK: Delegate methods
    func updateModel(){
        DispatchQueue.main.async(execute: {
            self.collection.reloadData()
        })
    }

    /**
     Adjust Search Bar size when rotating devices
     */
    func rotationDetected(){
        searchController.searchBar.sizeToFit()
    }
    
    // MARK: Search Results Controller 🔍
    func configureSearchController() {
        searchController = UISearchController(searchResultsController: SuggestionsVC())
        
        searchController.definesPresentationContext = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search more Heroes, i.e. X-Men"
        searchController.searchBar.delegate = self
        searchController.delegate = self
        searchController.searchBar.sizeToFit()
        collection.superview!.addSubview(searchController.searchBar)
        //print(searchController.delegate)
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
    
    func launchNetworkQuery(){
        (searchController.searchResultsController as! SuggestionsVC).search(keystrokes: _keystrokes)
    }
    
    // MARK: API request to get suggestions 📡
    func updateSearchResults(for searchController: UISearchController) {
        if let keystrokes = searchController.searchBar.text , keystrokes != "" {
            if let searchTimer = _searchTimer {
                searchTimer.invalidate()
            }
            _keystrokes = keystrokes
            _searchTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MasterViewController.launchNetworkQuery),userInfo: nil, repeats: false)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        _model.resetHeroSuggestions()
        collection.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        _model.resetHeroSuggestions()
        collection.reloadData()
    }
    
    //MARK: Collection View Data Soure
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.StoryboardIds.HERO_CELL, for: indexPath) as! HeroCell
        
        _model.indexPathRow = indexPath.row

        let cellViewModel = HeroCellModel(hero: _model.heroes[indexPath.row])
        cell.presentCell(cellViewModel)
        
        if (indexPath.item == (_model.count - 1)) && (_model.count > _currentOffset){
            _currentOffset += 20
            _model.moreHeroes(currentOffset: _currentOffset)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _model.count
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
                    let hero = _model[heroAt: selectedHeroIndex]
                    detailsVC.setModelWith(hero)
                }

            }
        }
    }
}
