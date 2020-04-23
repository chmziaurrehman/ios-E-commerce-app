//
//  QCreditTransactionsCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 05/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QCreditTransactionsCell: UICollectionViewCell {

    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblCredit: UILabel!
    
    @IBOutlet weak var dateAddedLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        localizeStrings()
        // Initialization code
    }
    // Localized strings
    func localizeStrings() {
        dateAddedLabel.text       = LocalizationSystem.shared.localizedStringForKey(key: "Date_added", comment: "")
        descLabel.text   = LocalizationSystem.shared.localizedStringForKey(key: "Description", comment: "")
    }
}
