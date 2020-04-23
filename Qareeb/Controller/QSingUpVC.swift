//
//  QLogInVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 16/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import GoogleSignIn
import CoreLocation

class QSignUpVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtMobile: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtConfirmPassword: UITextField!
//    @IBOutlet weak var txtCity: UITextField!
    
    //localizable labels
    @IBOutlet weak var lblFirstname: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblMobile: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblConfirmPassword: UILabel!
//    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblLoginWith: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var btnSignUp: UIButton!
    @IBOutlet weak var lblTerms: UILabel!
    
    var previousVC : UIViewController?
    
    var googleData: GIDGoogleUser?
    var faceBookData: Any?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizeStrings()

//        APIManager.sharedInstance.keyboardType(txtMobile, true)
        APIManager.sharedInstance.keyboardType(txtFirstName, false)
        APIManager.sharedInstance.keyboardType(txtLastName, false)
        APIManager.sharedInstance.keyboardType(txtEmail, false)
        APIManager.sharedInstance.keyboardType(txtAddress, false)
//        APIManager.sharedInstance.keyboardType(txtCity, false)
        txtEmail.delegate = self
        
        txtMobile.keyboardType = .asciiCapableNumberPad
        txtMobile.textContentType = .telephoneNumber
        txtMobile.delegate = self
        txtMobile.addTarget(self, action: #selector(textFiedDidChange(_:)), for: .editingChanged)
        // Do any additional setup after loading the view.
     

        if let gUser = self.googleData {
            txtEmail.text = gUser.profile.email
            txtFirstName.text = gUser.profile.givenName
            txtLastName.text = gUser.profile.familyName
        }
        if let fUser = self.faceBookData {
            let rslt = fUser as! NSDictionary
            txtEmail.text       = rslt["email"] as? String
            txtFirstName.text   = rslt["first_name"] as? String
            txtLastName.text    = rslt["last_name"] as? String
        }
        
    }
    
    @objc func textFiedDidChange(_ sender: Any) {
        //Matching country code with suggestion
        for country in APIManager.sharedInstance.countryList {
            let prefix = country.dial_code! // What ever you want may be an array and step thru it
            if txtMobile.text!.hasPrefix(prefix) {
                txtMobile.text  = txtMobile.text?.replacingOccurrences(of: prefix, with: "")
                break
            }
        }
        txtMobile.text = txtMobile.text?.applyPatternOnNumbers(pattern: "##########", replacmentCharacter: "#")
    }
    
    //Localization configrations
    func localizeStrings() {
        
        lblEmail.text = LocalizationSystem.shared.localizedStringForKey(key: "Email", comment: "")
        lblOr.text = LocalizationSystem.shared.localizedStringForKey(key: "And", comment: "")
        lblTerms.text = LocalizationSystem.shared.localizedStringForKey(key: "By_signing_up_you_are_agree_to_our", comment: "")
        lblFirstname.text = LocalizationSystem.shared.localizedStringForKey(key: "FirstName", comment: "")
        lblLastName.text = LocalizationSystem.shared.localizedStringForKey(key: "LastName", comment: "")
        lblMobile.text = LocalizationSystem.shared.localizedStringForKey(key: "Mobile", comment: "")
        lblAddress.text = LocalizationSystem.shared.localizedStringForKey(key: "Address", comment: "")
//        lblCity.text = LocalizationSystem.shared.localizedStringForKey(key: "City", comment: "")
        lblLoginWith.text = LocalizationSystem.shared.localizedStringForKey(key: "Login_with", comment: "")
        btnSignUp.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "SIGNUP", comment: ""), for: .normal)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
//        APIManager.sharedInstance.getCurrentAddress { (address) in
//            self.txtAddress.text = address
//        }
                APIManager.sharedInstance.userCurrentAddress()
                APIManager.sharedInstance.currentAddressCallback = {(address) -> Void in
                    self.txtAddress.text = address
                }
        
    }
    
    //MARK:- Button Actions
    
    @IBAction func btnSignUp(_ sender: Any) {
        
        switch CLLocationManager.authorizationStatus() {
     
        case .restricted, .denied, .notDetermined:
            let alertController = UIAlertController (title: "Qareeb قريب", message: "Allow Qareeb قريب to access your location", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = NSURL(string: UIApplication.openSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url as URL)
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            break
            
        case .authorizedWhenInUse, .authorizedAlways:
            getUserLocation()
            break
        }
    }
    
    func getUserLocation() {
        _ =  Location.getLocation(withAccuracy:.block, frequency: .oneShot, onSuccess: { [weak self] location in
            //            print("loc \(location.coordinate.longitude)\(location.coordinate.latitude)")
            DEVICE_LAT = location.coordinate.latitude
            DEVICE_LONG = location.coordinate.longitude
            
            let geoCoder = CLGeocoder()
            let location = CLLocation(latitude: DEVICE_LAT, longitude: DEVICE_LONG)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, error in
                if let city = placemarks?[0].locality{
                    self!.signUpService(city: city)
                } else {
                    self!.signUpService(city: "Default")
                }
                
            })
            
            }, onError: { (last, error) in
                print("Something bad has occurred \(error)")
        })

    }
    
    func signUpService(city: String) {
        if txtFirstName.text != "" && txtLastName.text != "" && (txtEmail.text != "" && (txtEmail.text?.validEmail())!) && (txtMobile.text != "" && txtMobile.text?.count == 9) && txtAddress.text != "" && (txtPassword.text == txtConfirmPassword.text){
                    self.signUpService(mobile: "966\(self.txtMobile.text!)", city: city)
        }else if txtFirstName.text == "" {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter first name" )
        }else if txtLastName.text == "" {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter last name" )
        }else if txtEmail.text == "" || !(txtEmail.text?.validEmail())!{
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter a valid email address" )
        }else if txtMobile.text == "" || (txtMobile.text?.count)! < 9 {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter your mobile number" )
        }else if txtAddress.text == "" {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter your address" )
        }else if txtPassword.text == "" {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter password" )
        }else if txtConfirmPassword.text == "" {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please confirm password" )
        }else if txtConfirmPassword.text !=  txtPassword.text  {
            APIManager.sharedInstance.customPOP(isError: true, message: "Password and confirm password does not match" )
        }

    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtMobile  {
            if textField.text != "" || string != "" {
                let res = (textField.text ?? "") + string
                return Double(res) != nil
            }
        } else if textField == txtEmail {
            if (string == " ") {
                return false
            }
        }
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    func signUpService(mobile: String, city: String) {
        
        let params = [
                        "firstname" : self.txtFirstName.text!,
                        "lastname"  : self.txtLastName.text!,
                        "email"     : self.txtEmail.text!,
                        "telephone" : mobile,
                        "address_1" : self.txtAddress.text!,
                        "city"      : city,
                        "password" : self.txtPassword.text!,
                        "confirm"   : self.txtConfirmPassword.text!
            ] as [String : AnyObject]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: SIGNUP, header: header, serviceType: "SIGN UP" , modelType: UserModel.self, success: { (response) in
            let user = (response as! UserModel)
            debugPrint(user)
            if user.success == true {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QVerifyOTPVC") as! QVerifyOTPVC
//                vc.userInfo = user.customer_info
//                vc.previousVC = self.previousVC
                APIManager.sharedInstance.loginUserService(email: (user.customer_info?.email)!, password: (self.txtPassword.text)!, controller: self, previousVC: self.previousVC, isSocial: false, gData: nil, fData: nil)
//                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.message ?? ERROR_MESSAGE)
            }
            
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: ERROR_MESSAGE)
            debugPrint(error)
        }, showHUD: true)
    }
}













