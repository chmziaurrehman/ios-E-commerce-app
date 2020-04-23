//
//  MDVBPList.swift
//  MdVisionVitals
//
//  Created by Muhammad Zia Ur Rehman on 4/25/18.
//  Copyright © 2018 MDVisions. All rights reserved.
//

import UIKit

class QAddressCell: UITableViewCell {

    @IBOutlet weak var lbAddress: UILabel!
    
    @IBOutlet weak var radioButton: UIViewX!
    @IBOutlet weak var outerView: UIViewX!
    
    var togle = true
    var onOff = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor.clear
        self.backgroundView = selectionView
    }

    override func draw(_ rect: CGRect) {
        

        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundView?.backgroundColor = selected ? #colorLiteral(red: 0, green: 0.5416094661, blue: 0.7650926709, alpha: 0) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
        self.radioButton.backgroundColor = selected ?  UIColor(named: "boring_green") : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        APIManager.sharedInstance.animateRadioButton(button: self.radioButton)
        // Configure the view for the selected state
    }
    

//    @objc func tempCellAllSelection(_ notification: NSNotification) {
//        if !onOff {
//            radioButton.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//            onOff = true
//            //            self.unSelectCallBack()
//            APIManager.sharedInstance.selectAllVitals = false
////            NotificationCenter.default.post(name: .removeAllVitals, object: nil)
//
//        }else {
//            radioButton.backgroundColor = #colorLiteral(red: 0, green: 0.5416094661, blue: 0.7650926709, alpha: 1)
//            onOff = false
//            APIManager.sharedInstance.selectAllVitals = true
////            NotificationCenter.default.post(name: .allVitals, object: nil)
//            //            self.multupleDeleteCallBack()
//        }
//    }
    
    
}
