//
//  HeroDetailVC.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 12/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

class HeroDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    
    var hero : Hero?
    var comics = [Comic]()
    var comicOffset = 0
    
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
            self.collection.reloadData()
            
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Collection View Data Source
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(COMIC_CELL, forIndexPath: indexPath) as? ComicCell {
            
            let comic: Comic!
            comic = comics[indexPath.row]
            cell.configureCell(comic)
            
            if (indexPath.item == comics.count - 1) && (comics.count > comicOffset){
                print("fetching more comics")
                comicOffset += 20
                //TODO
                //apiClient.sharedInstance.moreComics(comicOffset)
            }
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return comics.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
}
