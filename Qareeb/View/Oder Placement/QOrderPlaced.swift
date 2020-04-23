//
//  QOrderPlaced.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 27/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QOrderPlaced: UIView {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTimeSlot: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOrderNumber: UILabel!
    @IBOutlet weak var lblTotal: UILabel!
    
    @IBOutlet weak var labelOrderPlaced: UILabel!
    @IBOutlet weak var labelPlaced: UILabel!
    @IBOutlet weak var labelAccepted: UILabel!
    @IBOutlet weak var labelShopping: UILabel!
    @IBOutlet weak var labelOnTheWay: UILabel!
    @IBOutlet weak var labelDelivered: UILabel!
    @IBOutlet weak var LabelTotal: UILabel!
    @IBOutlet weak var btnThanks: UIButton!
    
    var dismissView:(()-> Void)!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        localizeStrings()
    }
 
    @IBAction func btnThankYou(_ sender: Any) {
        self.dismissView()
    }
    
    func setValues(amount:  String, deliveryTime: String, firstName: String, dayValue: String) {
        self.lblTotal.text = amount
        self.lblTimeSlot.text = deliveryTime
        self.lblName.text = "\(LocalizationSystem.shared.localizedStringForKey(key: "Good_news", comment: "")). \(firstName)"
        self.lblOrderNumber.text = "\(LocalizationSystem.shared.localizedStringForKey(key: "your_order", comment: ""))  \(LocalizationSystem.shared.localizedStringForKey(key: "has_been_placed", comment: ""))"
        self.lblDate.text = dayValue
    }
    
    //Localization configrations
    func localizeStrings() {
        
        labelOrderPlaced.text = LocalizationSystem.shared.localizedStringForKey(key: "order_placed", comment: "")
        labelPlaced.text = LocalizationSystem.shared.localizedStringForKey(key: "Placed", comment: "")
        labelAccepted.text = LocalizationSystem.shared.localizedStringForKey(key: "Accepted", comment: "")
        labelShopping.text = LocalizationSystem.shared.localizedStringForKey(key: "Shopping", comment: "")
        labelOnTheWay.text = LocalizationSystem.shared.localizedStringForKey(key: "On_the_way", comment: "")
        labelDelivered.text = LocalizationSystem.shared.localizedStringForKey(key: "Delivered", comment: "")
        LabelTotal.text = LocalizationSystem.shared.localizedStringForKey(key: "Total", comment: "").capitalized
        btnThanks.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "OK_THANKS", comment: ""), for: .normal)

    }
}
