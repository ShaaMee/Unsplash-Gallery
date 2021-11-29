//
//  UnsplashGalleryTabBarController.swift
//  Unsplash Gallery
//
//  Created by user on 29.11.2021.
//

import UIKit

class UnsplashGalleryTabBarController: UITabBarController {
    
    init(){
        super.init(nibName: nil, bundle: nil)
        setUpTabBarController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpTabBarController() {
        let flowLayout = UICollectionViewFlowLayout()
        let homeScreenVC = HomeScreenCollectionViewController(collectionViewLayout: flowLayout)
        let favouritesVC = FavouritesTableViewController()
        
        homeScreenVC.title = "Gallery"
        homeScreenVC.tabBarItem.image = UIImage(systemName: "photo")
        favouritesVC.title = "Favourites"
        favouritesVC.tabBarItem.image = UIImage(systemName: "star")

        let homeScreenNavigationVC = UINavigationController(rootViewController: homeScreenVC)
        let favouritesNavigationVC = UINavigationController(rootViewController: favouritesVC)
        
        setViewControllers([homeScreenNavigationVC, favouritesNavigationVC], animated: false)
    }
}


