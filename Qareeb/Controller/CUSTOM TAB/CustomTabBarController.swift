//
//  ASD.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 09/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation

//
//  CustomTabBarController.swift
//  For Medium Article @yalcinozd
//
//  Created by Yalcin Ozdemir on 19/08/2018.
//
import UIKit

class CustomTabBarController:  UITabBarController, UITabBarControllerDelegate {
    
    let menuButton = UIButton(frame: CGRect.zero)
    @IBOutlet weak var sideMenu: UIViewX!
    
    var dismissBtn : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.alpha = 0
        return button
    }()
    
 
    override func viewDidLoad(){
        super.viewDidLoad()
        self.delegate = self
        setupMiddleButton()
        sideMenu.frame = CGRect(x: -sideMenu.frame.width, y: 0, width: view.frame.width / 1.3, height: view.frame.height)
        dismissBtn.addTarget(self, action: #selector(closeSideBar), for: .touchUpInside)
        menuButton.addTarget(self, action: #selector(tabbarButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuButton.frame.origin.y = self.view.bounds.height - menuButton.frame.height - self.view.safeAreaInsets.bottom - 5
    }
    
    //MARK: UITabbar Delegate
    func setupMiddleButton() {
        let numberOfItems = CGFloat(tabBar.items!.count)
        let tabBarItemSize = CGSize(width: tabBar.frame.width / numberOfItems, height: tabBar.frame.height)
        menuButton.frame = CGRect(x: 0, y: 0, width: tabBarItemSize.width + 2, height: tabBar.frame.size.height + 5)
        var menuButtonFrame = menuButton.frame
        menuButtonFrame.origin.y = self.view.bounds.height - menuButtonFrame.height - self.view.safeAreaInsets.bottom
        menuButtonFrame.origin.x = 0
        menuButton.frame = menuButtonFrame
        menuButton.setImage(#imageLiteral(resourceName: "menu_black"), for: .normal)
        menuButton.backgroundColor = UIColor.black
//        self.view.addSubview(menuButton)
        self.tabBarController?.tabBar.addSubview(menuButton)
        self.view.layoutIfNeeded()
    }
    @IBAction func btnSideMenu(_ sender: UIButton) {
        window.addSubview(dismissBtn)
        dismissBtn.frame = window.bounds
        openSideMenu()
    }
    func openSideMenu(){
        window.addSubview(self.sideMenu)
        
        //        self.dismissbutton.isHidden = false
        self.sideMenu.bringSubviewToFront(self.view)
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.selectRow(at: IndexPath(row: self.index, section: 0), animated: true, scrollPosition: .none)
        UIView.animate(withDuration: 0.3) {
            self.dismissBtn.alpha = 0.5
            self.sideMenu.frame.origin.x = 0
            self.view.frame.origin.x = self.sideMenu.frame.width
            self.navigationController?.navigationBar.frame.origin.x = self.sideMenu.frame.width
            //            self.sta.frame.origin.x = self.sideMenu.frame.width
        }
        
    }
    
    @objc func closeSideBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenu.frame.origin.x = -self.sideMenu.frame.width
            self.view.frame.origin.x = 0
            self.navigationController?.navigationBar.frame.origin.x = 0
            self.dismissBtn.alpha = 0
            //            self.mainView.frame.origin.x = 0
            //            self.sta.frame.origin.x = 0
        }) { (true) in
            //            self.dismissbutton.isHidden = true
            self.sideMenu.removeFromSuperview()
            self.dismissBtn.removeFromSuperview()
        }
    }
    @objc func tabbarButton() {
        openSideMenu()
        
    }
    
}



