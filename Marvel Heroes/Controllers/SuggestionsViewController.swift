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
    
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        listenToNotifications()
    }

    override func viewWillAppear(animated: Bool) {
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    //MARK: API request 📡
    func listenToNotifications(){
        NSNotificationCenter.defaultCenter().addObserverForName(NOTIFICATION_SUGGESTIONS, object: nil, queue: nil) {  (_) in
            self.heroes = apiClient.sharedInstance.getHeroSuggestions()
            print("Suggestion heroes coming: \(self.heroes.count)")
            self.tableView.reloadData()
        }
    }
    
    //MARK: UI
    func setupUI(){
        self.tableView.registerNib(UINib(nibName: SUGGESTION_CELL, bundle: nil), forCellReuseIdentifier: SUGGESTION_CELL)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("suggestionCell", forIndexPath: indexPath) as! suggestionCell
        
        cell.configureCell(heroes[indexPath.row])
        cell.fadeIn()
        return cell
    }
    
    //MARK: Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HeroDetailVC") as! HeroDetailVC
        vc.hero = heroes[indexPath.row]
        vc.presentedModally = true
        presentViewController(vc, animated: true) {_ in }
        
    }

}




