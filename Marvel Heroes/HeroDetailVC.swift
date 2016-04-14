

//
//  HeroDetailVC.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 12/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

class HeroDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var comicsEmptyStateLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func dismissButton(sender: AnyObject) {
        
        
        //self.presentingViewController!.navigationController?.dismissViewControllerAnimated(true, completion: nil)
        //self.presentedViewController?.dismissViewControllerAnimated(true, completion: {_ in })
        //self.presentingViewController?.dismissViewControllerAnimated(true, completion: {_ in })
        self.dismissViewControllerAnimated(true, completion: {_ in })
    }
    @IBOutlet weak var comicsActivityIndicator: UIActivityIndicatorView!
    
    var hero : Hero?
    var comics = [Comic]()
    var comicOffset = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = NSURL.init(string: self.hero!.thumbnailUrl) {
            self.image.hnk_setImageFromURL(url)
            self.avatarImage.hnk_setImageFromURL(url)
            self.avatarImage.layer.borderWidth = 1
            self.avatarImage.layer.masksToBounds = false
            self.avatarImage.layer.borderColor = UIColor.whiteColor().CGColor
            //thumbImg.layer.cornerRadius = thumbImg.frame.height / 2
            self.avatarImage.layer.cornerRadius = 10
            self.avatarImage.clipsToBounds = true
        }
        nameLabel.text = hero!.name
        detailDescriptionLabel.text = hero!.desc
        idLabel.text = String(hero!.heroId)
        comicsActivityIndicator.startAnimating()
        
        
        
        print("Presenting viewController: \(self.presentingViewController)")
//        
//        if (self.presentingViewController != nil) {
//            closeButton.hidden = false
//        } else {
//            closeButton.hidden = true
//        }
        
        apiClient.sharedInstance.fetchComics(hero!.heroId)

        NSNotificationCenter.defaultCenter().addObserverForName(NOTIFICATION_COMICS, object: nil, queue: nil) {  (_) in
            self.comicsActivityIndicator.stopAnimating()
            self.comics = apiClient.sharedInstance.getComics()
            print("Comics coming from notification")
            print(self.comics.count)
            
            if self.comics.count == 0{
                self.comicsEmptyStateLabel.hidden = false
            }
            self.collection.reloadData()
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let yOffset = self.scrollView.contentOffset.y * 0.2
        let availableOffset = min(yOffset, 60)
        let contentRectYOffset = availableOffset / avatarImage.frame.size.height
        avatarImage.layer.contentsRect = CGRectMake(0.0, contentRectYOffset, 1, 1);
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
