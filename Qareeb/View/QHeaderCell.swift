//
//  QHeaderCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 25/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QHeaderCell: UITableViewCell {

    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblTotalItems: UILabel!
    @IBOutlet weak var headerView: UIViewX!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblLImit: UILabel!
    @IBOutlet weak var imgBarCode: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
