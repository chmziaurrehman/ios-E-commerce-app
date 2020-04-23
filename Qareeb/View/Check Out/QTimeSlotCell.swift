//
//  QTimeSlotCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 26/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QTimeSlotCell: UITableViewCell {

    @IBOutlet weak var imgTime: UIImageView!
    @IBOutlet weak var lblTimeSlot: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundView?.backgroundColor = selected ? UIColor.clear : UIColor.clear
        self.imgTime.image = selected ?  #imageLiteral(resourceName: "timeGreen") : #imageLiteral(resourceName: "time")
        //        APIManager.sharedInstance.animateRadioButton(button: self.radioButton)
        // Configure the view for the selected state
    }
    
}

