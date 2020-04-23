//
//  QUpdateProfileVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 16/09/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QUpdateProfileVC: UIViewController {

    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtCity: UITextField!
    
    @IBOutlet weak var lblFirstname: UILabel!
    @IBOutlet weak var lblLastName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCity: UILabel!
    
    @IBOutlet weak var btnUpdate: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        localizeStrings()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {//
            APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
            return
        }
        
        getAddresses(customerId: customerId)
        
        let customer = APIManager.sharedInstance.getCustomer()
        txtFirstName.text = customer?.firstname
        txtLastName.text = customer?.lastname
        
    }
    
    
    // Localized strings
    func localizeStrings() {
        lblFirstname.text   = LocalizationSystem.shared.localizedStringForKey(key: "FirstName", comment: "")
        lblLastName.text    = LocalizationSystem.shared.localizedStringForKey(key: "LastName", comment: "")
        lblAddress.text     = LocalizationSystem.shared.localizedStringForKey(key: "Address", comment: "")
        lblCity.text        = LocalizationSystem.shared.localizedStringForKey(key: "City", comment: "")
        btnUpdate.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Update", comment: ""), for: .normal)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func btnUpdate(_ sender: Any) {
        
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
            APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
            return
        }
        
        updateProfile(customerId: customerId, firstname: self.txtFirstName.text ?? "", lastname: self.txtLastName.text ?? "", city: self.txtCity.text ?? "", address: self.txtAddress.text ?? "")
    }
    
    func updateProfile(customerId: String, firstname: String, lastname: String, city: String, address: String) {
        let params = [
                "firstname" : firstname,
                "lastname" : lastname,
                "city" : city,
                "address" : address,
                "customer_id" : customerId
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: UPDATE_PROFILE, header: header, serviceType: "User PROFILE" , modelType: UpdateProfile.self, success: { (response) in
            let responseData = (response as! UpdateProfile)
            if responseData.status?.lowercased() == "success" {
                APIManager.sharedInstance.customPOP(isError: false, message: "Profile Updated")
                var userInfo = APIManager.sharedInstance.getCustomer()
                userInfo?.firstname = firstname
                userInfo?.lastname = lastname
                APIManager.sharedInstance.setCustomer(in: userInfo ??  Customer())
            } else {
                APIManager.sharedInstance.customPOP(isError: true, message: responseData.msg ?? ERROR_MESSAGE)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
    
    
    func getAddresses(customerId: String) {
        let idofAppointmet = [ "": "" ] as [String : AnyObject]
        let url = GET_ADDRESS + customerId
        
        WebServiceManager.get(params : idofAppointmet, serviceName: url, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Forgot Password", modelType: AddressModel.self, success: { (response) in
            let data = (response as! AddressModel)
            if data.msg?.lowercased() == "success" {
                if data.result?.count != 0 {
                    self.txtAddress.text = data.result?[0].address_1
                    self.txtCity.text = data.result?[0].city
                }
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
            }
            
        }) { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
    }
    
}
