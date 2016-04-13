//
//  HeroDetailVC.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 12/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

class HeroDetailVC: UIViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    var hero : Hero?
    var comics = [Comic]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = NSURL.init(string: self.hero!.thumbnailUrl) {
            //let _ = Shared.imageCache
            
            self.image.hnk_setImageFromURL(url)
        }
        nameLabel.text = hero!.name
        detailDescriptionLabel.text = hero!.desc
        idLabel.text = String(hero!.heroId)
        
        apiClient.sharedInstance.fetchComics(hero!.heroId)

        NSNotificationCenter.defaultCenter().addObserverForName(NOTIFICATION_COMICS, object: nil, queue: nil) {  (_) in
            self.comics = apiClient.sharedInstance.getComics()
            print("Comics coming from notification")
            print(self.comics.count)
        }
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    
}
