//
//  QAddNewAddress.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 26/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QAddNewAddress: UIView {
    @IBOutlet weak var lblfirstname: UITextField!
    @IBOutlet weak var lblLastName: UITextField!
    @IBOutlet weak var lblCity: UITextField!
    @IBOutlet weak var lblAddress: UITextField!
    
    
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var btnAdd: UIButton!
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        localizeStrings()
        
//        APIManager.sharedInstance.gettingLatLong { (lat, long) in
//            DEVICE_LAT  = lat
//            DEVICE_LONG = long
//        }
//        
        APIManager.sharedInstance.getCurrentAddress(currentAdd: { (address) in
            self.lblAddress.text = address
        })
    }
 
    var addAddress:(()-> Void)!

    @IBAction func btnAddAddress(_ sender: Any) {
        self.addAddress()
    }
    @IBAction func btnDismiss(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    //Localization configrations
    func localizeStrings() {
        
        firstNameLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "FirstName", comment: "")
        lastNameLabel.text  = LocalizationSystem.shared.localizedStringForKey(key: "LastName", comment: "")
        addressLabel.text   = LocalizationSystem.shared.localizedStringForKey(key: "Address", comment: "")
        cityLabel.text      = LocalizationSystem.shared.localizedStringForKey(key: "City", comment: "")
        btnAdd.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "add", comment: ""), for: .normal)

    }
}
