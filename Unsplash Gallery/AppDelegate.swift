//
//  AppDelegate.swift
//  Unsplash Gallery
//
//  Created by user on 21.11.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let flowLayout = UICollectionViewFlowLayout()
        let homeScreenVC = HomeScreenCollectionViewController(collectionViewLayout: flowLayout)
        let favouritesVC = FavouritesTableViewController()
        
        homeScreenVC.title = "Home Screen"
        favouritesVC.title = "Favourites"
        
        let homeScreenNavigationVC = UINavigationController(rootViewController: homeScreenVC)
        let favouritesNavigationVC = UINavigationController(rootViewController: favouritesVC)
        let tabBarController = UITabBarController()
        tabBarController.setViewControllers([homeScreenNavigationVC, favouritesNavigationVC], animated: false)
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

