//
//  QVerifyOTPVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 06/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QVerifyOTPVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblMessage : UILabel!
    @IBOutlet weak var txtPassword : UITextField!
    
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var btnVerify: UIButton!
    var userInfo: CustomerInfo?
    var previousVC : UIViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeStrings()
        txtPassword.delegate = self
        if #available(iOS 12.0, *) {
            txtPassword.textContentType = .oneTimeCode
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
        if let user = userInfo {
           lblMessage.text =  "Please enter Password sent to \(user.telephone ?? "") / \(user.email ?? "") or click back to change"
        }
    }
    
    //Localization configrations
    func localizeStrings() {
//        LocalizationSystem.shared.setLanguage(languageCode: language)
        title = LocalizationSystem.shared.localizedStringForKey(key: "verify", comment: "")
        lblPassword.text = LocalizationSystem.shared.localizedStringForKey(key: "password", comment: "")
        btnVerify.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "send", comment: ""), for: .normal)
        
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
        if let phone = userInfo?.telephone {
            verifyOTPService(password: self.txtPassword.text ?? "", mobile: phone)
        }else {
            print("Something is missing try again")
        }
    }
    
    
    func verifyOTPService(password: String, mobile: String) {
        
        let languageId = APIManager.sharedInstance.getLanguage()!.id
        
        let params = [  "password"   : password,
                        "mobile"     : mobile,
                        "language_id": languageId
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        
        WebServiceManager.poost(params: params, serviceName: VERIFY_OTP, header: header, serviceType: "VERIFY OTP" , modelType: UserModel.self, success: { (response) in
            let user = (response as! UserModel)
            if user.success == true {
                APIManager.sharedInstance.loginUserService(email: (self.userInfo?.email)!, password: (self.userInfo?.password)!, controller: self, previousVC: self.previousVC, isSocial: false, gData: nil, fData: nil)
            } else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.message ?? ERROR_MESSAGE)
            }
            
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
    
    

    
    
}
