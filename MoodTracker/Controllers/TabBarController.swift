//
//  TabBarController.swift
//  MoodTracker
//
//  Created by Altan on 22.08.2023.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let listVC = UINavigationController(rootViewController: ListViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "text.book.closed")
        listVC.tabBarItem.image = UIImage(systemName: "bookmark")
        
        tabBar.tintColor = UIColor(red: 104/255, green: 52/255, blue: 212/255, alpha: 1)
        
        setViewControllers([homeVC, listVC], animated: true)
    }

}
