//
//  SuggestionsVC.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 13/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

/**
 Table View with results from remote search
 It is created programmatically
 */

class SuggestionsVC: UITableViewController, ModelUpdaterDelegate{

    //MARK: Types
    typealias Model = SuggestionsModel

    private var _model = Model()
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialization
        _model = Model(theDelegate: self)
        setupUI()
        _model.tearUp()
    }
    
    func search(keystrokes: String){
        _model.search(keystrokes: keystrokes)
    }

    func updateModel() {
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
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
        return _model.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Consts.StoryboardIds.SUGGESTION_CELL, for: indexPath) as! SuggestionCell
        _model.indexPathRow = indexPath.row
        
        let suggestionCellViewModel = SuggestionCellModel(hero: _model.heroes[indexPath.row])
        cell.presentCell(suggestionCellViewModel)
        
        cell.fadeIn()
        return cell
    }
    
    //MARK: Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: Consts.StoryboardIds.HERO_DETAIL_VC) as! HeroDetailVC
        vc.setModelWith(_model[heroAt: indexPath.row])
        vc.presentedModally = true
        present(vc, animated: true) {_ in }
    }
}




