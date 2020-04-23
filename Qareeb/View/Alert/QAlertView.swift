//
//  QAlertView.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 06/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QAlertView: UIView {
    @IBOutlet weak var lblWarning: UILabel!
    @IBOutlet weak var imgWarning: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnNo: UIButton!
    @IBOutlet weak var btnYes: UIButton!
    
    var yes:(()-> Void)!
    var no:(()-> Void)!

    override func draw(_ rect: CGRect) {
        
        btnNo.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "NO", comment: ""), for: .normal)
        btnYes.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "YES", comment: ""), for: .normal)
        
    }
    

    @IBAction func btnYes(_ sender: Any) {
        self.yes()
    }
    @IBAction func btnNo(_ sender: Any) {
        self.no()
    }
}
