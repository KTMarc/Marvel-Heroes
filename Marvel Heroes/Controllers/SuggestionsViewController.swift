//
//  SuggestionsViewController.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

class SuggestionsViewController: UITableViewController/*,UISearchResultsUpdating*/ {

    
    var heroes = [Hero]()
    var selectedHero : Hero!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //createSampleData()
        
        self.tableView.registerClass(UITableViewCell.classForCoder(), forCellReuseIdentifier: "Cell")
        
        NSNotificationCenter.defaultCenter().addObserverForName(NOTIFICATION_SUGGESTIONS, object: nil, queue: nil) {  (_) in
            self.heroes = apiClient.sharedInstance.getHeroSuggestions()
            print("Suggestion heroes coming: \(self.heroes.count)")
            self.tableView.reloadData()
        }
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: - Table View
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        cell.textLabel?.text = heroes[indexPath.row].name
//        cell.detailTextLabel!.text = String(heroes[indexPath.row].heroId)
//        if let url = NSURL.init(string: self.heroes[indexPath.row].thumbnailUrl) {
//            cell.imageView!.hnk_setImageFromURL(url)
//        }
        
        heroes[indexPath.row].name
        return cell
    }
    
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

        
        //        performSegueWithIdentifier(SEGUE_TO_HERO_DETAIL_VC, sender: self)
    }




// MARK: - Segues

//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if segue.identifier == SEGUE_TO_HERO_DETAIL_VC {
//            let vc = (segue.destinationViewController as! UINavigationController).topViewController as! HeroDetailVC
//                vc.hero = selectedHero
//                vc.navigationItem.leftItemsSupplementBackButton = true
//        }
//    }
}




