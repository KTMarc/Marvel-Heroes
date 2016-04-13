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
        presentViewController(vc, animated: true) {_ in }
        
        
        //let vc = HeroDetailVC(nibName: "HeroDetailVC", bundle: nil)
        
//        if let navControllerExists = navigationController?.pushViewController(vc, animated: true){
//            
//        }
        
//        if let navController = navigationController {
//            navController.pushViewController(vc, animated: true)
//        } else {
//            let newNavControler = UINavigationController()
//            newNavControler.pushViewController(vc, animated: true)
        //}
        
//        if let navController = navigationController {
//            let destination = navController.topViewController as! HeroDetailVC
//            destination.hero = heroes[indexPath.row]
//            self.navigationController!.presentViewController(navController, animated: true, completion: nil)
//        } else {
//            let newNav = UINavigationController.init(coder: <#T##NSCoder#>)
//        }

        
    }

}




