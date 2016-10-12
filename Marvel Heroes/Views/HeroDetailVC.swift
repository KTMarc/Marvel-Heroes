

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
protocol HeroDetailDelegate : class {
    func updateModel()
}

class HeroDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, HeroDetailDelegate {
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
    
    //Types
    typealias Model = HeroDetailModel
    private var model = Model()

    var blurView = UIVisualEffectView()
    var presentedModally = false

    //TOOD: Remove when transition to MVVM is complete.
     /*Another view controller can set up this view controller's model by calling
     `setHero(_:)` on it.*/
    private var hero : Hero!
    func setHero(_ hero: Hero) {
        self.hero = hero
    }
    
    func setModelWith(_ hero: Hero) {
        model = Model(hero: hero, theDelegate : self )
    }
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        model.tearUp()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if presentedModally {
            NotificationCenter.default.post(
            name: Notification.Name(rawValue: Consts.Notifications.modal_heroDetail_dismissed.rawValue), object: self)
        }
    }
    
    //MARK: UI
    func setupUI(){
        if let /*url*/ _ = URL.init(string: self.model.hero.thumbnailUrl) {
            //Big Hero image
            //self.image.hnk_setImageFromURL(url)
            self.image.downloadAsyncFrom(self.model.hero.thumbnailUrl, contentMode: .scaleAspectFill)
            
            //Smaller Hero image
            //self.avatarImage.hnk_setImageFromURL(url)
            self.avatarImage.downloadAsyncFrom(self.model.hero.thumbnailUrl, contentMode: .scaleAspectFill)
            
            
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
            self.blurImage.downloadAsyncFrom(self.model.hero.thumbnailUrl, contentMode: .scaleAspectFill)
            
            self.blurImage.addSubview(effectView)
            blurView = UIVisualEffectView(effect: blurEffect)
            blurView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(blurView)
            blurView.alpha = 0.0
        }
        
        //Navigation Bar Setup
        self.navigationItem.title = model.hero.name
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 38, height: 38))
        imageView.contentMode = .scaleAspectFit
        let backImage = UIImage(named: "backButton.png")
        let backButton = UIBarButtonItem(image: backImage, style: UIBarButtonItemStyle.plain, target: self, action: #selector(HeroDetailVC.dismissVC))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.red
        
        closeButton.tintColor = UIColor.red
        nameLabel.text = model.hero.name
        detailDescriptionLabel.text = model.hero.desc
        idLabel.text = String(model.hero.heroId)
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
            
            let comic = model.comics[(indexPath as NSIndexPath).row]
            cell.configureCell(comic)
            
            if ((indexPath as NSIndexPath).item == model.comics.count - 1) && (model.comics.count > model.comicOffset){
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
        return model.comics.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: Delegate methods
    func updateModel(){
        if model.comics.count == 0{
            self.comicsEmptyStateLabel.isHidden = false
        }
        
        DispatchQueue.main.async(execute: {
            self.comicsActivityIndicator.stopAnimating()
            self.collection.reloadData()
        })
    }
    
    //MARK: Navigation
    func dismissVC(){
        _ = navigationController?.popViewController(animated: true)
    }
    
    deinit{
        model.tearDown()
    }
}
