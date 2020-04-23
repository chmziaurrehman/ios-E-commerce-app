//
//  EmptySegue.swift
//
//
//  Created by Aaqib Hussain on 03/08/2015.
//  Copyright (c) 2015 Kode Snippets. All rights reserved.
//

import UIKit

class EmptySegue: UIStoryboardSegue{
    
    override func perform() {
//    scale()
    }
    
    func scale() {
        let toViewController = self.destination
        let fromViewcontroller = self.source
        
        let containerView = fromViewcontroller.view.superview
        let originalCenter = fromViewcontroller.view.center
        
        toViewController.view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        toViewController.view.center = originalCenter
        
        containerView?.addSubview(toViewController.view)
        
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            toViewController.view.transform = CGAffineTransform.identity
        }) { (true) in
//            fromViewcontroller.present(toViewController, animated: false, completion: nil)
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
