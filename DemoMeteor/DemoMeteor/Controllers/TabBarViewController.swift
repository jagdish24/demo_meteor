//
//  TabBarViewController.swift
//  DemoMeteor
//
//  Created by Jagdish on 22/09/21.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        UITabBar.appearance().tintColor = UIColor(named: "app_green")
        
        for item in self.tabBar.items ?? [] {
            item.selectedImage = item.selectedImage?.withRenderingMode(.alwaysTemplate)
            item.image = item.image?.withRenderingMode(.alwaysTemplate)
        }

        
        self.createTabs()
    }
    
    fileprivate func createTabs() {
        
        let meteorVC = MeteorVC.instanceVC()
        let navMeteor = UINavigationController.init(rootViewController: meteorVC)
        navMeteor.tabBarItem = UITabBarItem.init(title: "Meteor", image: UIImage(named: "tab_meteor_white"), selectedImage: UIImage(named: "tab_meteor"))
        
        let favVC = FavoriteVC.instanceVC()
        let navFav = UINavigationController.init(rootViewController: favVC)
        navFav.tabBarItem = UITabBarItem.init(title: "Favorite", image: UIImage(named: "tab_favorite"), selectedImage: UIImage(named: "tab_favorite_green"))

        self.viewControllers = [navMeteor, navFav]
        
        self.selectedIndex = 0
        
        
    }


}
