//
//  MDVDatePicker.swift
//  MdVisionVitals
//
//  Created by Muhammad Zia Ur Rehman on 4/4/18.
//  Copyright © 2018 MDVisions. All rights reserved.
//

import UIKit

class MDVDatePicker: UIView {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
 

    @IBAction func btnDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBAction func btnDone(_ sender: Any) {
        self.removeFromSuperview()
    }
}
