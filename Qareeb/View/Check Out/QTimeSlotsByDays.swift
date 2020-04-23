//
//  QTimeSlotsByDays.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 26/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QTimeSlotsByDays: UIView {

    @IBOutlet weak var slotTableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblSelectDeliveryTime: UILabel!
    @IBOutlet weak var btnSaveDeliveryTime: UIButton!
    
    //    var addAddress:(()-> Void)!

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        localizeStrings()
    }
 
    
    @IBAction func btnClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    @IBAction func btnSaveDeliverytime(_ sender: Any) {
        self.removeFromSuperview()
    }
 
    
    //Localization configrations
    func localizeStrings() {
        lblSelectDeliveryTime.text = LocalizationSystem.shared.localizedStringForKey(key: "Select_Delivery_Time", comment: "")
        btnSaveDeliveryTime.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Save_Delivery_Time", comment: ""), for: .normal)
    }
}
