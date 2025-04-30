//
//  AppTabBarController.swift
//  RandomPicture
//
//  Created by Ivan Alexeevich on 28.04.2025.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
    }
    
    private func setupTabs() {
       
        let listViewController = ListViewController()
        let gridViewController = GridViewController()
        
        listViewController.tabBarItem = UITabBarItem(
            title: "List",
            image: UIImage(systemName: "list.bullet"),
            selectedImage: UIImage(systemName: "list.bullet.fill")
        )
        
        gridViewController.tabBarItem = UITabBarItem(
            title: "Grid",
            image: UIImage(systemName: "square.grid.3x3"),
            selectedImage: UIImage(systemName: "square.grid.3x3.fill")
        )
        
        let listNavController = UINavigationController(rootViewController: listViewController)
        let gridNavController = UINavigationController(rootViewController: gridViewController)
        
        viewControllers = [listNavController, gridNavController]
    }
}



