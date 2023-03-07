//
//  TabBarController.swift
//  BearBurp
//
//  Created by Ziqian Wang on 11/30/22.
//

import Foundation
import UIKit

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabbarHeight()
        self.tabbarRadius()
    }
    
    func tabbarRadius(){
        
        self.tabBar.layer.masksToBounds = true
        self.tabBar.layer.cornerRadius = 35
        self.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
    }
    
    func tabbarHeight(){
        var tabFrame = tabBar.frame
        tabFrame.size.height = 200
        tabFrame.origin.y = view.frame.size.height - 100
        tabBar.frame = tabFrame
    }
    
}
