//
//  QForgotPasswordVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 01/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QForgotPasswordVC: UIViewController {
    
    @IBOutlet weak var lblEmail: UITextField!
    
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var btnSend: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeStrings()
        // Do any additional setup after loading the view.
    }
    
    //Localization configrations
    func localizeStrings() {
        
//        LocalizationSystem.shared.setLanguage(languageCode: language)
        title = LocalizationSystem.shared.localizedStringForKey(key: "ForgotPassword", comment: "")
        lbEmail.text = LocalizationSystem.shared.localizedStringForKey(key: "Email", comment: "")
        btnSend.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "send", comment: ""), for: .normal)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnSend(_ sender: Any) {
        if lblEmail.text!.validEmail() {
            forgotPasswordService(email: lblEmail.text!)
        }else {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter a valid email address")
        }
        
    }
    
}



// Forgot Password service

extension  QForgotPasswordVC {
    
    func forgotPasswordService(email: String) {
        let params = [  "email"         : email,
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: FORGOT_PASSWORD, header: header, serviceType: "FORGOT PASSWORD" , modelType: UserModel.self, success: { (response) in
            let user = (response as! UserModel)
            debugPrint(user)
            if user.message == "success" {
                APIManager.sharedInstance.customPOP(isError: false, message: "Mail has been sent successfully")
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.message ?? ERROR_MESSAGE)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
}
