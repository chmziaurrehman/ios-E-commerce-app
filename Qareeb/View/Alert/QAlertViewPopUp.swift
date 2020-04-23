//
//  QAlertView.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 06/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QAlertViewPopUp: UIView {
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var imgWarning: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func btnNo(_ sender: Any) {
        self.removeFromSuperview()
    }
}
