//
//  QNavigationController.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 27/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    override init(rootViewController : UIViewController) {
        super.init(rootViewController : rootViewController)
    }
    
    override init(navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        super.init(navigationBarClass : navigationBarClass, toolbarClass : toolbarClass)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        if let _ = APIManager.sharedInstance.getStore()?.seller_id {

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "QHomeVC") as! QHomeVC
            self.setViewControllers([newViewController], animated: false)
        }else {

            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "QFavoriteStoreVC") as! QFavoriteStoreVC
            self.setViewControllers([newViewController], animated: false)
        }
      
    }

}
