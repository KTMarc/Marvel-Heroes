

//
//  HeroDetailVC.swift
//  Marvel Heroes
//
//  Created by Marc Humet on 12/4/16.
//  Copyright © 2016 SPM. All rights reserved.
//

import UIKit

/**
 Detail View for Hero 
 Includes a Collection View with Comics
 */


class HeroDetailVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate, ModelUpdaterDelegate {
    //MARK: Outlets
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
    
    //MARK: Types
    typealias Model = HeroDetailModel
    private var model = Model()

    //MARK: Properties
    var blurView = UIVisualEffectView()
    var presentedModally = false

    /**
     Meant to be called from the parent VC
     We set the model via Depency injection.
     */
    func setModelWith(_ hero: Hero) {
        model = Model(hero: hero, theDelegate : self )
        model.tearUp()
    }
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        if let  _ = URL.init(string: self.model.hero.thumbnailUrl) {
            //Big Hero image
            self.image.downloadAsyncFrom(self.model.hero.thumbnailUrl, contentMode: .scaleAspectFill)
            
            //Smaller Hero image
            self.avatarImage.downloadAsyncFrom(self.model.hero.thumbnailUrl, contentMode: .scaleAspectFill)
            self.avatarImage.layer.borderWidth = 3
            self.avatarImage.layer.masksToBounds = false
            self.avatarImage.layer.borderColor = UIColor.black.cgColor
            self.avatarImage.layer.cornerRadius = 10
            self.avatarImage.clipsToBounds = true
        }
        
        //MARK: Navigation Bar Setup
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
            
            let comic = model[comicAt: indexPath.row]
            //MVVM: VC owns the cell an creates it with a new ViewModel owned by the cell. (Dependency injection)
            let cellViewModel = ComicCellModel(comic: comic)
            cell.presentCell(cellViewModel)
            
            if (indexPath.item == model.count - 1) && (model.count > model.comicOffset){
                //TODO: Fetch More comics with infinite scroll like we do it with heroes in the Master VC
                //print("fetching more comics")
                //comicOffset += 20
                //apiClient.manager.moreComics(comicOffset)
            }
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: Delegate methods
    func updateModel(){
        if model.count == 0{
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
    
}
