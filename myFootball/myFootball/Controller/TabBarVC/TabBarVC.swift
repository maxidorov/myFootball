//
//  TabBarVC.swift
//  myFootball
//
//  Created by Maxim Sidorov on 25.11.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit

class TabBarVC: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        let todayVC = TodayVC()
        let navTodayVC = UINavigationController()
        navTodayVC.viewControllers = [todayVC]
        
        let favoritesVC = FavoritesVC()
        let navFavoritesVC = UINavigationController()
        navFavoritesVC.viewControllers = [favoritesVC]
        
        self.viewControllers = [navTodayVC, navFavoritesVC]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let items = tabBar.items else { return }
        items[0].title = "Today"
        items[1].title = "Favorites"
    }
}
