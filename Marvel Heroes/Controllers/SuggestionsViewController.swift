//
//  SuggestionsViewController.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

class SuggestionsViewController: UITableViewController{

    
    var heroes = [Hero]()
    var selectedHero : Hero!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.registerNib(UINib(nibName: SUGGESTION_CELL, bundle: nil), forCellReuseIdentifier: SUGGESTION_CELL)
        tableView.backgroundColor = UIColor.blackColor()
        tableView.separatorColor = UIColor.lightGrayColor()
        
        NSNotificationCenter.defaultCenter().addObserverForName(NOTIFICATION_SUGGESTIONS, object: nil, queue: nil) {  (_) in
            self.heroes = apiClient.sharedInstance.getHeroSuggestions()
            print("Suggestion heroes coming: \(self.heroes.count)")
            self.tableView.reloadData()
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Table View Data Source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("suggestionCell", forIndexPath: indexPath) as! suggestionCell
        
        cell.configureCell(heroes[indexPath.row])

        return cell
    }
    
    //MARK: Table View Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //selectedHero = heroes[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("HeroDetailVC") as! HeroDetailVC
        vc.hero = heroes[indexPath.row]
        vc.presentedModally = true
        presentViewController(vc, animated: true) {_ in }
        
    }

}




