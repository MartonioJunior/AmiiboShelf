//
//  CustomTabBarController.swift
//  AmiiboShelf
//
//  Created by Martônio Júnior on 24/10/18.
//  Copyright © 2018 Martônio Júnior. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController,UITabBarControllerDelegate {
    // MARK: TabBarController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let fromView = selectedViewController?.view,
              let toView = viewController.view, toView != fromView else { return true }
        
        UIView.transition(from: fromView, to: toView, duration: 0.3, options: [.transitionCrossDissolve], completion: nil)
        return true
    }
}
