

//
//  HeroDetailVC.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 12/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
import Haneke

/**
 Detail View for Hero 
 Includes a Collection View with Comics
 */

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
    
    @IBOutlet weak var blurImage: UIImageView!
    @IBAction func dismissButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: {_ in })
    }
    @IBOutlet weak var comicsActivityIndicator: UIActivityIndicatorView!
    
    var hero : Hero!
    var comics = [Comic]()
    var comicOffset = 0
    var blurView = UIVisualEffectView()
    var presentedModally = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let url = NSURL.init(string: self.hero.thumbnailUrl) {
            //Big Hero image
            self.image.hnk_setImageFromURL(url)
            
            //Smaller Hero image
            self.avatarImage.hnk_setImageFromURL(url)
            self.avatarImage.layer.borderWidth = 3
            self.avatarImage.layer.masksToBounds = false
            self.avatarImage.layer.borderColor = UIColor.blackColor().CGColor
            //thumbImg.layer.cornerRadius = thumbImg.frame.height / 2
            self.avatarImage.layer.cornerRadius = 10
            self.avatarImage.clipsToBounds = true
            
            //Blurred image background
            let blurEffect: UIBlurEffect = UIBlurEffect(style: .Dark)
            let effectView = UIVisualEffectView(effect: blurEffect)
            effectView.frame = self.view.frame
            self.blurImage.hnk_setImageFromURL(url)
            self.blurImage.addSubview(effectView)
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(blurView)
            blurView.alpha = 0.0
        }

        //Navigation Bar Setup
        self.navigationItem.title = hero.name
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .ScaleAspectFit
        let backImage = UIImage(named: "backButton.png")
        let backButton = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.Plain, target: self, action: #selector(HeroDetailVC.popVC))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.redColor()
        
        closeButton.tintColor = UIColor.redColor()
        nameLabel.text = hero.name
        detailDescriptionLabel.text = hero.desc
        idLabel.text = String(hero.heroId)
        comicsActivityIndicator.startAnimating()
        
        closeButton.hidden = presentedModally ? false : true
        
        //Get the comics
        apiClient.sharedInstance.fetchComics(hero.heroId)
        listenToNotifications()
        
    }
    //MARK: API request 📡
    func listenToNotifications(){
        
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
                //TODO Fetch More comics like we do it with heroes in the Master VC
                //print("fetching more comics")
                //comicOffset += 20
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
    
    //MARK: Navigation
    func popVC(){
        navigationController?.popViewControllerAnimated(true)
    }
    
    
}
