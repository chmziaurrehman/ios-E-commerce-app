//
//  MDVBPList.swift
//  MdVisionVitals
//
//  Created by Muhammad Zia Ur Rehman on 4/25/18.
//  Copyright © 2018 MDVisions. All rights reserved.
//

import UIKit

class QVarientCell: UITableViewCell {

    @IBOutlet weak var lblTitle:    UILabel!
    @IBOutlet weak var radioButton: UIViewX!
    @IBOutlet weak var outerView:   UIViewX!
    @IBOutlet weak var checkboxOuterView: UIViewX!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    
    var togle = true
    var onOff = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let selectionView = UIView()
        selectionView.backgroundColor = UIColor.clear
        self.backgroundView = selectionView
 
    }
 
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            self.backgroundView?.backgroundColor = selected ? #colorLiteral(red: 0, green: 0.5416094661, blue: 0.7650926709, alpha: 0) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//            self.radioButton.backgroundColor = selected ?  #colorLiteral(red: 0.4431372549, green: 0.6980392157, blue: 0.3882352941, alpha: 1) : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.imgCheckBox.image = selected ? #imageLiteral(resourceName: "checkMarkActive") : UIImage()
    }
}
