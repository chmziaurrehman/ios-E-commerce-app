//
//  MDVSideBarCell.swift
//  MdVisionVitals
//
//  Created by Muhammad Zia Ur Rehman on 4/10/18.
//  Copyright © 2018 MDVisions. All rights reserved.
//

import UIKit

class MDVSideBarCell: UITableViewCell {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var imgSideMenu: UIImageView!
     @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = selected ? #colorLiteral(red: 0.3411764706, green: 0.2235294118, blue: 0.5254901961, alpha: 1) : UIColor.clear
     
//        self.lblTitle.textColor = selected ? #colorLiteral(red: 0, green: 0.5416094661, blue: 0.7650926709, alpha: 1) : #colorLiteral(red: 0.3014175892, green: 0.3014255166, blue: 0.3014212251, alpha: 1)
        // Configure the view for the selected state
    }
    override var isSelected: Bool {
        didSet{
            
        }
    }
   
}
