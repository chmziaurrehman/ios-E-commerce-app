//
//  QWishlistCellCollectionViewCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 23/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QWishlistCell: UICollectionViewCell {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var lblSpecial: UILabel!
    
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    var addToCart:(()-> Void)!
    var delete:(()-> Void)!
    var share:(()-> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        localizeStrings()
        // Initialization code
    }

    @IBAction func btnAddToCart(_ sender: Any) {
        self.addToCart()
    }
    @IBAction func btnDelete(_ sender: Any) {
        self.delete()
    }
    @IBAction func btnShare(_ sender: Any) {
        self.share()
    }
    
    
    //Localization configrations
    func localizeStrings() {
        //        LocalizationSystem.shared.setLanguage(languageCode: language)
        btnShare.setTitle("  \(LocalizationSystem.shared.localizedStringForKey(key: "Share", comment: ""))", for: .normal)
        btnDelete.setTitle("  \(LocalizationSystem.shared.localizedStringForKey(key: "Delete", comment: ""))", for: .normal)
 
    }
}
