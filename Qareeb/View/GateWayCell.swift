//
//  GateWayCell.swift
//  American One
//
//  Created by M Zia Ur Rehman Ch. on 24/01/2018.
//  Copyright © 2018 M Zia Ur Rehman Ch. All rights reserved.
//

import UIKit

class GateWayCell: UICollectionViewCell {
//    @IBOutlet weak var bImage: UIImageView!
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var heading: UILabel!
    @IBOutlet weak var subHeading: UILabel!
    @IBOutlet weak var enableNotification: UIViewX!
    @IBOutlet weak var notNow: UIButton!
    @IBOutlet weak var btnLanguage: ButtonX!

    
    var closeHandler:(()-> Void)!
    var notnowHandler:(()-> Void)!
    var language:((_ sender: ButtonX) -> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    @IBAction func enableNotifi(_ sender: Any) {
        self.closeHandler()
    }
    @IBAction func notnowBtn(_ sender: Any) {
        self.notnowHandler()
    }
    @IBAction func btnLang(_ sender: ButtonX) {
        self.language(sender)
    }
    
    
    func setUpUI() {
        DispatchQueue.main.async {
            if APIManager.sharedInstance.getLanguage()?.id == "1" {// Language is English
                
                self.heading.font = UIFont(name: FONT.enRegular.rawValue, size: self.heading.font.pointSize)
                self.subHeading.font = UIFont(name: FONT.enRegular.rawValue, size: self.subHeading.font.pointSize)
                self.notNow.titleLabel?.font = UIFont(name: FONT.enRegular.rawValue, size: (self.notNow.titleLabel?.font.pointSize)!)
                self.btnLanguage.titleLabel?.font = UIFont(name: FONT.enRegular.rawValue, size: (self.btnLanguage.titleLabel?.font.pointSize)!)
                
            }else {// Language is arabic
                
                self.heading.font = UIFont(name: FONT.arBold.rawValue, size: self.heading.font.pointSize)
                self.subHeading.font = UIFont(name: FONT.arRegular.rawValue, size: self.subHeading.font.pointSize)
                self.notNow.titleLabel?.font = UIFont(name: FONT.arRegular.rawValue, size: self.notNow.titleLabel!.font.pointSize)
                self.btnLanguage.titleLabel?.font = UIFont(name: FONT.arRegular.rawValue, size: (self.btnLanguage.titleLabel?.font.pointSize)!)
            }
            //Lacalizable values
            self.btnLanguage.setTitle(Language.value(key: "CHANGE_LANGUAGE"), for: .normal)
            self.notNow.setTitle(Language.value(key: "GET_STARTED"), for: .normal)
        }
    }

}
