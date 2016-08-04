//
//  SuggestionsViewController.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

/**
 Table View with results from remote search
 It is created programmatically
 */

class SuggestionsViewController: UITableViewController{

    
    var heroes = [Hero]()
    let MasterVCModel = MasterViewControllerModel()
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        listenToNotifications()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: API request 📡
    func listenToNotifications(){
        NSNotificationCenter.defaultCenter().addObserverForName(Consts.Notifications.suggestions.rawValue, object: nil, queue: nil) {  (_) in
            self.heroes = apiClient.sharedInstance.getHeroSuggestions()
            //print("Suggested results count: \(self.heroes.count)")
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    //MARK: UI
    func setupUI(){
        self.tableView.registerNib(UINib(nibName:Consts.StoryboardIds.SUGGESTION_CELL, bundle: nil), forCellReuseIdentifier: Consts.StoryboardIds.SUGGESTION_CELL)
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor.lightGrayColor()
    }
    
    // MARK: Table View Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Consts.StoryboardIds.SUGGESTION_CELL, forIndexPath: indexPath) as! SuggestionCell
        
        cell.configureCell(heroes[indexPath.row])
        cell.fadeIn()
        return cell
    }
    
    //MARK: Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier(Consts.StoryboardIds.HERO_DETAIL_VC) as! HeroDetailVC
        vc.setHero(heroes[indexPath.row])
        vc.presentedModally = true
        presentViewController(vc, animated: true) {_ in }
    }

}




