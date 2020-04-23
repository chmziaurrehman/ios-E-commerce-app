//
//  QStoreCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 18/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import Cosmos


class QStoreCell: UICollectionViewCell {
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var imgLimit: UIImageView!
    @IBOutlet weak var imgTimeSlot: UIImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var lblLimit: UILabel!
    @IBOutlet weak var lblTimeSlot: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var lblStatusColor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        ratingView.
    }

}
