//
//  QOrderCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 28/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QOrderInfoCell: UICollectionViewCell {

    @IBOutlet weak var imgOrder: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblUPC: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    var addtoCart:(()-> Void)!
    var share:(()-> Void)!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func btnAddToCart(_ sender: Any) {
        self.addtoCart()
    }
    @IBAction func btnShare(_ sender: Any) {
        self.share()
    }
}
