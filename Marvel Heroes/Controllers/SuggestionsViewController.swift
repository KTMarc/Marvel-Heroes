//
//  SuggestionsViewController.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
//import Haneke

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
        NotificationCenter.default.removeObserver(self)
    }
    
    
    //MARK: API request 📡
    func listenToNotifications(){
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.suggestions.rawValue), object: nil, queue: nil) {  (_) in
            self.heroes = apiClient.sharedInstance.getHeroSuggestions()
            //print("Suggested results count: \(self.heroes.count)")
            DispatchQueue.main.async(execute: {
                self.tableView.reloadData()
            })
        }
    }
    
    //MARK: UI
    func setupUI(){
        self.tableView.register(UINib(nibName:Consts.StoryboardIds.SUGGESTION_CELL, bundle: nil), forCellReuseIdentifier: Consts.StoryboardIds.SUGGESTION_CELL)
        tableView.backgroundColor = UIColor.black
        tableView.separatorColor = UIColor.lightGray
    }
    
    // MARK: Table View Data Source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.StoryboardIds.SUGGESTION_CELL, for: indexPath) as! SuggestionCell
        
        cell.configureCell(heroes[(indexPath as NSIndexPath).row])
        cell.fadeIn()
        return cell
    }
    
    //MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Consts.StoryboardIds.HERO_DETAIL_VC) as! HeroDetailVC
        vc.setHero(heroes[(indexPath as NSIndexPath).row])
        vc.presentedModally = true
        present(vc, animated: true) {_ in }
    }

}




