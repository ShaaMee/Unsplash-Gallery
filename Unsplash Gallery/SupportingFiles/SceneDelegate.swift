//
//  SceneDelegate.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let flowLayout = UICollectionViewFlowLayout()
        let homeScreenVC = HomeScreenCollectionViewController(collectionViewLayout: flowLayout)
        let favouritesVC = FavouritesTableViewController()
        
        homeScreenVC.title = "Gallery"
        homeScreenVC.tabBarItem.image = UIImage(systemName: "photo")
        favouritesVC.title = "Favourites"
        favouritesVC.tabBarItem.image = UIImage(systemName: "star")

        let homeScreenNavigationVC = UINavigationController(rootViewController: homeScreenVC)
        let favouritesNavigationVC = UINavigationController(rootViewController: favouritesVC)
        
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([homeScreenNavigationVC, favouritesNavigationVC], animated: false)
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }

}

