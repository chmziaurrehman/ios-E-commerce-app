//
//  QAccountVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 21/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QAccountVC: UIViewController {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var lblProfile: UILabel!
    @IBOutlet weak var lblFirstname: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    let logInView : QLoginView = UIView.fromNib()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizeStrings()
        
        logInView.logIn = {() -> Void in
            if self.logInView.txtPassword.text != "" && (self.logInView.txtEmail.text != "" && (self.self.logInView.txtEmail.text?.validEmail())!) {

                APIManager.sharedInstance.loginUserServicePopUp(email: self.logInView.txtEmail.text!, password: self.logInView.txtPassword.text!, controller: self, loginView: self.logInView, closure: { (success) in
                    if success {
                        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {return}
                        self.loginUserService(customerId: customerId)
                    }
                })
                
            }else if self.logInView.txtEmail.text == "" {
                APIManager.sharedInstance.customPOP(isError: true, message: "Please enter a valid email address" )
            }else if self.logInView.txtPassword.text == ""{
                APIManager.sharedInstance.customPOP(isError: true, message: "Please enter password" )
            }
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let customerId = APIManager.sharedInstance.getCustomer()?.customer_id {
            loginUserService(customerId: customerId)
        }else {
            self.view.addSubview(self.logInView)
            self.logInView.frame = self.view.bounds
        }
       
    }
    
    // Localized strings
    func localizeStrings() {
        lblEmail.text       = LocalizationSystem.shared.localizedStringForKey(key: "Email", comment: "")
        lblFirstname.text   = LocalizationSystem.shared.localizedStringForKey(key: "FirstName", comment: "")
        lblLastName.text    = LocalizationSystem.shared.localizedStringForKey(key: "LastName", comment: "")
        lblMobile.text      = LocalizationSystem.shared.localizedStringForKey(key: "Mobile", comment: "")
        lblAddress.text     = LocalizationSystem.shared.localizedStringForKey(key: "Address", comment: "")
        lblCity.text        = LocalizationSystem.shared.localizedStringForKey(key: "City", comment: "")
        lblProfile.text     = LocalizationSystem.shared.localizedStringForKey(key: "Profile", comment: "")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func loginUserService(customerId: String) {
        let params = [  "customer_id"         : customerId
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: ACCOUNT, header: header, serviceType: "User PROFILE" , modelType: CustomerInfo.self, success: { (response) in
            let user = (response as! CustomerInfo)
            debugPrint(user)
            if user.msg == nil {
                self.txtFirstName.text = user.firstname
                self.txtLastName.text = user.lastname
                self.txtEmail.text = user.email
                self.txtMobile.text = user.telephone
                self.txtAddress.text = user.address
                self.txtCity.text = user.city
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
