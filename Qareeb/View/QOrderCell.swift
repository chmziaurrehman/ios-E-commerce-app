//
//  QOrderCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 25/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QOrderCell: UICollectionViewCell {

    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblReceived: UILabel!
    @IBOutlet weak var lblDeliverySlot: UILabel!
    @IBOutlet weak var lblTotal: UILabel!

    @IBOutlet weak var lblPlaced: UILabel!
    @IBOutlet weak var lblAccepted: UILabel!
    @IBOutlet weak var lblShopping: UILabel!
    @IBOutlet weak var lblOnTheWay: UILabel!
    @IBOutlet weak var lblDelivered: UILabel!
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderDate: UILabel!
    @IBOutlet weak var lblDeliverySlost: UILabel!
    @IBOutlet weak var lblReceivedBy: UILabel!
    @IBOutlet weak var lblTot: UILabel!
    
    @IBOutlet weak var btnDetails: UIButton!
    
    @IBOutlet weak var imgPlaced: UIImageView!
    @IBOutlet weak var imgAccepted: UIImageView!
    @IBOutlet weak var imgShopping: UIImageView!
    @IBOutlet weak var imgOnTheWay: UIImageView!
    @IBOutlet weak var imgDelivered: UIImageView!
    
    @IBOutlet weak var btnPayConst: NSLayoutConstraint!
    
    var viewDetails:(()-> Void)!
    var payOrder:(()-> Void)?
    var imgLblStatus = [(UIImageView,UILabel)]()

    override func awakeFromNib() {
        super.awakeFromNib()
        localizeStrings()
        imgLblStatus = [(imgPlaced,lblPlaced),(imgAccepted,lblAccepted),(imgShopping,lblShopping),(imgOnTheWay,lblOnTheWay),(imgDelivered,lblDelivered)]
        // Initialization code
        
    }
    
    @IBAction func btnDetails(_ sender: Any) {
        self.viewDetails()
    }
    
    @IBAction func btnPayOrder(_ sender: Any) {
        self.payOrder?()
    }
    
    func isAction( _ active : [(UIImageView,UILabel)] , _ inActive : [(UIImageView,UILabel)])  {
        self.layoutIfNeeded()
        for ac in active {
            ac.0.image = #imageLiteral(resourceName: "checkMarkActive")
            ac.1.textColor = .red
        }
        for inAc in inActive {
            inAc.0.image = #imageLiteral(resourceName: "checkMarkNotActive")
            inAc.1.textColor = .green
        }
        self.layoutIfNeeded()
    }
    
    func showPayButton(isShowing: Bool) {
        if isShowing {
            self.btnPayConst.constant = 100
        } else {
            self.btnPayConst.constant = 0
        }
    }
    
    //Localization configrations
    func localizeStrings() {
 
        lblPlaced.text = LocalizationSystem.shared.localizedStringForKey(key: "Placed", comment: "")
        lblAccepted.text = LocalizationSystem.shared.localizedStringForKey(key: "Accepted", comment: "")
        lblShopping.text = LocalizationSystem.shared.localizedStringForKey(key: "Shopping", comment: "")
        lblOnTheWay.text = LocalizationSystem.shared.localizedStringForKey(key: "On_the_way", comment: "")
        lblDelivered.text = LocalizationSystem.shared.localizedStringForKey(key: "Delivered", comment: "")
        
        lblOrderId.text = LocalizationSystem.shared.localizedStringForKey(key: "Order_ID", comment: "")
        lblOrderDate.text = LocalizationSystem.shared.localizedStringForKey(key: "Order_Date", comment: "")
        lblDeliverySlost.text = LocalizationSystem.shared.localizedStringForKey(key: "Delivery_Slots", comment: "")
        lblReceivedBy.text = LocalizationSystem.shared.localizedStringForKey(key: "Received_By", comment: "")
        lblTot.text = LocalizationSystem.shared.localizedStringForKey(key: "Total", comment: "")
        btnDetails.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Details", comment: ""), for: .normal)


    }
    
}
