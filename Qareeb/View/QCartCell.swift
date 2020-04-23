//
//  QCartCell1.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 25/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QCartCell: UITableViewCell {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblSpecial: UILabel!
    @IBOutlet weak var specialView: UIViewX!
    
    var plus:(()-> Void)!
    var minum:(()-> Void)!
    var delete:(()-> Void)!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.backgroundColor = selected ? UIColor.white : UIColor.white
        
        // Configure the view for the selected state
    }


    @IBAction func btnMinus(_ sender: Any) {
        self.minum()
    }
    @IBAction func btnPlus(_ sender: Any) {
        self.plus()
    }
    @IBAction func btnDelete(_ sender: Any) {
        self.delete()
    }
}
