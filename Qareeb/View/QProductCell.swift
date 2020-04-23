//
//  QProductCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 19/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QProductCell: UICollectionViewCell {
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var imgSale: UIImageView!
    @IBOutlet weak var lblSalePercent: UILabel!
    @IBOutlet weak var lblCount: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var lblProductName: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var labelConst: NSLayoutConstraint!
    @IBOutlet weak var specialConst: NSLayoutConstraint!
    @IBOutlet weak var roundedView: UIViewX!
    @IBOutlet weak var btnIsFavourite: UIButton!
    
    var count = 1
    var plus:(()-> Void)!
    var minus:(()-> Void)!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        localizeStrings()
    }
    
    
    
    //Localization configrations
    func localizeStrings() {
//        if APIManager.sharedInstance.getLanguage()?.id == "1" {
//            lblProductName.font = UIFont(name: ENGLISH_REGULAR, size: 10)
//        }else {
//            lblProductName.font = UIFont(name: ARABIC_REGULAR, size: 10)
//        }
    }
    func isOutOfStock( _ isOutOfStock: Bool)  {
//        DispatchQueue.main.async {
//            if isOutOfStock {
//                self.btnAddToCart.setImage(UIImage(), for: .normal)
//                self.btnAddToCart.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "outOfStock", comment: ""), for: .normal)
//                self.btnAddToCart.isUserInteractionEnabled = false
//            } else {
//                self.btnAddToCart.setImage(#imageLiteral(resourceName: "addToCartIcon"), for: .normal)
//                self.btnAddToCart.setTitle("", for: .normal)
//                self.btnAddToCart.isUserInteractionEnabled = true
//
//            }
//        }
    }
    
  // Discount price setting
    func discountSetUp( isDiscount : Bool , _ amount : String) {
        if isDiscount {
            imgSale.isHidden        = !isDiscount
            lblSalePercent.isHidden = !isDiscount
            lblSalePercent.text     = amount + "%"
        }else {
            imgSale.isHidden        = !isDiscount
            lblSalePercent.isHidden = !isDiscount
        }
    }
    
      //MARK: - BUTTON ACTIONS
    @IBAction func btnFavorite(_ sender: Any) {
        
    }
    @IBAction func btnAddToCart(_ sender: UIButton) {
        sender.isHidden = true
        self.plus()
    }
    @IBAction func btnMinus(_ sender: Any) {
        if Int(lblCount.text!)! == 1 {
            btnAddToCart.isHidden = false
        }
        self.minus()
    }
    @IBAction func btnPlus(_ sender: Any) {
//        count += 1
//        self.lblCount.text = "\(count)"
        self.plus()
    }
}
