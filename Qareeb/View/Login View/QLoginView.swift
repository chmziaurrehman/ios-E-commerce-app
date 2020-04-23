//
//  QLoginView.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 18/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QLoginView: UIView {

    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!


    var logIn:(()-> Void)!

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        localizeStrings()
        btnLogin.layer.cornerRadius = 2
        btnLogin.clipsToBounds = true
    }
    
    
 
    @IBAction func btnLogin(_ sender: Any) {
        self.logIn()
    }
    
    
    
    //Localization configrations
    func localizeStrings() {
//        LocalizationSystem.shared.setLanguage(languageCode: language)
        lblEmail.text = LocalizationSystem.shared.localizedStringForKey(key: "Email", comment: "")
        lblPassword.text = LocalizationSystem.shared.localizedStringForKey(key: "password", comment: "")
        btnLogin.setTitle(" "+LocalizationSystem.shared.localizedStringForKey(key: "LOGIN", comment: "")+"  ", for: .normal)
    }
}
