

//
//  HeroDetailVC.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 12/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit
//import Haneke

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
    @IBAction func dismissButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {_ in })
    }
    @IBOutlet weak var comicsActivityIndicator: UIActivityIndicatorView!
    
    private var hero : Hero!
    var comics = [Comic]()
    var comicOffset = 0
    var blurView = UIVisualEffectView()
    var presentedModally = false

    /*
     Another view controller can set up this view controller's model by calling
     `setHero(_:)` on it.
     */
    func setHero(_ hero: Hero) {
        self.hero = hero
    }
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        listenToNotifications()
        //Ask for comics
        apiClient.singleton.fetchComics(hero.heroId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if presentedModally {
            NotificationCenter.default.post(
            name: Notification.Name(rawValue: Consts.Notifications.modal_heroDetail_dismissed.rawValue), object: self)
        }
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: API request 📡
    func listenToNotifications(){
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: Consts.Notifications.comics.rawValue), object: nil, queue: nil) {  (_) in
            
            self.comics = apiClient.singleton.getComics()
            print("Received Comics: \(self.comics.count)")
            
            if self.comics.count == 0{
                self.comicsEmptyStateLabel.isHidden = false
            }
            
            DispatchQueue.main.async(execute: {
            self.comicsActivityIndicator.stopAnimating()
                self.collection.reloadData()
            })
            
        }
    }
    
    
    //MARK: UI
    func setupUI(){
        if let /*url*/ _ = URL.init(string: self.hero.thumbnailUrl) {
            //Big Hero image
            //self.image.hnk_setImageFromURL(url)
            self.image.downloadAsyncFrom(self.hero.thumbnailUrl, contentMode: .scaleAspectFill)
            
            //Smaller Hero image
            //self.avatarImage.hnk_setImageFromURL(url)
            self.avatarImage.downloadAsyncFrom(self.hero.thumbnailUrl, contentMode: .scaleAspectFill)
            
            
            self.avatarImage.layer.borderWidth = 3
            self.avatarImage.layer.masksToBounds = false
            self.avatarImage.layer.borderColor = UIColor.black.cgColor
            //thumbImg.layer.cornerRadius = thumbImg.frame.height / 2
            self.avatarImage.layer.cornerRadius = 10
            self.avatarImage.clipsToBounds = true
            
            //Blurred image background
            let blurEffect: UIBlurEffect = UIBlurEffect(style: .dark)
            let effectView = UIVisualEffectView(effect: blurEffect)
            effectView.frame = self.view.frame
            //self.blurImage.hnk_setImageFromURL(url)
            self.blurImage.downloadAsyncFrom(self.hero.thumbnailUrl, contentMode: .scaleAspectFill)
            
            self.blurImage.addSubview(effectView)
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(blurView)
            blurView.alpha = 0.0
        }
        
        //Navigation Bar Setup
        self.navigationItem.title = hero.name
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let backImage = UIImage(named: "backButton.png")
        let backButton = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(HeroDetailVC.dismissVC))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        
        closeButton.tintColor = UIColor.red
        nameLabel.text = hero.name
        detailDescriptionLabel.text = hero.desc
        idLabel.text = String(hero.heroId)
        comicsActivityIndicator.startAnimating()
        
        closeButton.isHidden = presentedModally ? false : true

    }
    
    //MARK: Scroll View Delegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = self.scrollView.contentOffset.y * 0.2
        let availableOffset = min(yOffset, 60)
        let contentRectYOffset = availableOffset / avatarImage.frame.size.height
        avatarImage.layer.contentsRect = CGRect(x: 0.0, y: contentRectYOffset, width: 1, height: 1);
    }
    
    
    //MARK: Collection View Data Source
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Consts.StoryboardIds.COMIC_CELL, for: indexPath) as? ComicCell {
            
            let comic: Comic!
            comic = comics[(indexPath as NSIndexPath).row]
            cell.configureCell(comic)
            
            if ((indexPath as NSIndexPath).item == comics.count - 1) && (comics.count > comicOffset){
                //TODO: Fetch More comics with infinite scroll like we do it with heroes in the Master VC
                //print("fetching more comics")
                //comicOffset += 20
                //apiClient.singleton.moreComics(comicOffset)
            }
            
            return cell
            
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comics.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: Navigation
    func dismissVC(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    
}
