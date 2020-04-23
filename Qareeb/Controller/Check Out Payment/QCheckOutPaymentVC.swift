//
//  QCheckOutPaymentVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 11/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import CheckoutKit
import LocalAuthentication
import Alamofire

class QCheckOutPaymentVC: UIViewController, UITextFieldDelegate ,UIPickerViewDelegate , UIPickerViewDataSource {

    let madaList = [
        "588845", "588846","636120","968201", "484783","968203","489317", "410685","446672","588850","554180","537767","588982","588851","428331","419593","440647","493428","417633","446393","968205","486094","489318","432328","543357","968202","549760","535989","589005","605141","483010","439956","440795","539931","468540","588847","462220","486095","489319","489319","434107","529415","588849","536023","508160","968204","483011", "439954",  "446404",  "558848", "468541", "400861",  "455708",  "486096", "445564", "428672", "431361", "535825", "968209", "513213", "531095",
        "422817", "483012",  "457865",  "557606", "468542", "409201", "588848",  "504300", "968211", "428673", "604906", "543085", "524514", "585265", "530906","422818", "589206", "968208", "968210", "468543", "458456", "455036", "440533", "401757",  "968206", "521076", "524130", "529741", "588983", "532013", "422819", "968207"
    ]

    
    var pickerContent: [[String]] = []
    let months  = [1,2,3,4,5,6,7,8,9,10,11,12]
    let years   = [2019,2020,2021,2022,2023,2024,2025,2026,2027,2028,2029,2030,2031,2032,2033,2034,2035,2036,2036,2038,2039,2040,2041,2042]
    var month   = "1"
    var year    = "2019"
    let errorColor = UIColor(red: 204.0/255.0, green: 112.0/255.0, blue: 115.0/255.0, alpha: 0.3)
    
    var amount : String!
    var orderIds : String!
    var isMada = false
    let redirectView : QRedirectView = UIView.fromNib()
    lazy var keychain = KeychainQareeb()
    
    let thankYouScreen : QOrderPlaced = UIView.fromNib()
    var day = ""
    var lblDeliveryTime: String?
    var firstName: String?
    var orderHistory = false
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var cvvField: UITextField!
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var dateField: UITextField!
    @IBOutlet weak var cardTokenButton: UIButton!
    
    @IBAction func dateFieldTouch(_ sender: AnyObject) {
        datePicker.isHidden = false
        doneButton.isHidden = false
        cardTokenButton.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        redirectView.dismissView = { ()-> Void in
            APIManager.sharedInstance.responseCode = "10000"
            self.thankYouScreen.setValues(amount: self.amount, deliveryTime:  self.lblDeliveryTime ?? "", firstName: self.firstName ?? "", dayValue: self.day)
        }
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap(_:)))
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.thankYouScreen.dismissView  = {() -> Void in
             self.thankYouScreen.removeFromSuperview()
            
            if self.orderHistory {
                self.navigationController?.popViewController(animated: true)
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "QTabbarNavigationController") as! QTabbarNavigationController
                window.rootViewController = vc
                window.makeKeyAndVisible()
            }   
        }
        
        self.redirectView.dismissView = {()-> Void in
            APIManager.sharedInstance.upDateOrderStatus(orderId: self.orderIds, isFromOrderHistory: false, controller: self)
        }
        
    }
    
    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        
        self.view.endEditing(true)
        datePicker.isHidden = true
        doneButton.isHidden = true
        cardTokenButton.isHidden = false
        
    }
    
    @IBAction func finishEdit(_ sender: AnyObject) {
        datePicker.isHidden = true
        doneButton.isHidden = true
        cardTokenButton.isHidden = false
    }
    
    @IBAction func doneButton(_ sender: AnyObject) {
        datePicker.isHidden = true
        doneButton.isHidden = true
        cardTokenButton.isHidden = false
    }

    // returns the number of 'columns' to display.
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.pickerContent.count
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.pickerContent[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerContent[component][row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 { month = self.pickerContent[0][row] }
        else { year = self.pickerContent[1][row] }
        updateDate()
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = self.pickerContent[component][row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor: UIColor(named: "blueberry")!])
        
        return myTitle
    }
    
    fileprivate func updateDate() {
        dateField.text = "\(month) / \(year)"
    }
    
    func textFieldShouldBeginEditing( _ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    //    override func canPerformAction(_ action: Selector, withSender sender: AnyObject?) -> Bool {
    //        // Disable copy, select all, paste
    //        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {
    //            return false
    //        }
    //        // Default
    //        return super.canPerformAction(action, withSender: sender)
    //    }
    
    
    fileprivate func validateCardInfo(_ number: String, expYear: String, expMonth: String, cvv: String) -> Bool {
        var err: Bool = false
        resetFieldsColor()
        if (!CardValidator.validateCardNumber(number)) {
            err = true
            numberField.backgroundColor = errorColor
            self.cardTokenButton.isEnabled = true
        }
        if (!CardValidator.validateExpiryDate(month, year: year)) {
            err = true
            dateField.backgroundColor = errorColor
            self.cardTokenButton.isEnabled = true
        }
        if (cvv == "") {
            err = true
            cvvField.backgroundColor = errorColor
            self.cardTokenButton.isEnabled = true
        }
        return !err
    }
    
    fileprivate func resetFieldsColor() {
        numberField.backgroundColor = UIColor.white
        dateField.backgroundColor = UIColor.white
        cvvField.backgroundColor = UIColor.white
    }
    
    @IBAction func getCardToken(_ sender: UIButton) {
        sender.isEnabled = false
        getPaymentToken()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateField.delegate = self
        pickerContent.append([])
        for m in 0  ..< months.count  {
            pickerContent[0].append(months[m].description)
        }
        pickerContent.append([])
        for y in 0 ..< years.count {
            pickerContent[1].append(years[y].description)
        }
        datePicker.delegate = self
        datePicker.isHidden = true
        doneButton.isHidden = true
        cardTokenButton.isHidden = false
        numberField.keyboardType = .decimalPad

        guard let cardName = try? keychain.string(forKey: "cardName"),
                let expiryMonth = try? keychain.string(forKey: "month"),
                 let expiryYear = try? keychain.string(forKey: "year"),
                  let cvv = try? keychain.string(forKey: "cvv"),
                    let cardNumber = try? keychain.string(forKey: "cardNumber") else {
                        print("Could not retrieve credentials from the Keychain")
                        self.keychain.isFirstTime = true
                        return
        }
        
        authenticateWithBiometrics { (authenticationError) in

            if let _ = authenticationError {
                DispatchQueue.main.async {
                    self.cardTokenButton.isEnabled = true
                }
//                APIManager.sharedInstance.customPOP(isError: true, message: "Could not authenticate using biometrics. Reason: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.keychain.isFirstTime = false
                    self.nameField.text = cardName
                    self.numberField.text = cardNumber
                    self.dateField.text = "\(expiryMonth ?? "1") / \(expiryYear ?? "2019")"
                    self.cvvField.text = cvv
                    self.month = expiryMonth ?? "1"
                    self.year = expiryYear ?? "2019"
                }
            }
        }
        
        
        APIManager.sharedInstance.popViewController = { () -> Void in
            self.navigationController?.popViewController(animated: true)
            APIManager.sharedInstance.customPOP(isError: false, message: "Transection successfully performed")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isMadaCard() {
        if let madaText = self.numberField.text {
                   for value in madaList {
                       if madaText.prefix(6) == value {
                           self.isMada = true
                           break
                       }else {
                           self.isMada = false
                       }
                   }
               }
    }
    
    func getPaymentToken() {
        
                isMadaCard()// Checking entered card is Mada or not.
        
                var ck: CheckoutKit? = nil
                do {
                    try ck = CheckoutKit.getInstance("pk_79a5860e-f7ba-466a-b339-5b0db8bfb751")
                } catch _ as NSError {
        //            let errorController = self.storyboard?.instantiateViewController(withIdentifier: "ErrorController") as! ErrorController
        //            self.present(errorController, animated: true, completion: nil)
                }
                if ck != nil {
                    if (validateCardInfo(numberField.text!, expYear: year, expMonth: month, cvv: cvvField.text!)) {
                        resetFieldsColor()
                        var card: Card? = nil
                        do {
                            try card = Card(name: nameField.text!, number: numberField.text!, expYear: year, expMonth: month, cvv: cvvField.text!, billingDetails: nil)
                        } catch let err as CardError {
                            self.cardTokenButton.isEnabled = true
                            switch(err) {
                            case CardError.invalidCVV: cvvField.backgroundColor = errorColor
                            case CardError.invalidExpiryDate: dateField.backgroundColor = errorColor
                            case CardError.invalidNumber: numberField.backgroundColor = errorColor
                            }
                        } catch _ as NSError {
                            
                        }
                        
                        if card != nil {
                            ck!.createCardToken(card!, completion: { ( resp: Response<CardTokenResponse>) -> Void in
                                if (resp.hasError) {
                                    debugPrint(resp.error.debugDescription)
                                    APIManager.sharedInstance.customPOP(isError: true, message: "Something went wrong try again.")
                                    self.cardTokenButton.isEnabled = true
                                } else {
                                    self.proceedPayment(token: (resp.model?.cardToken)!, amount: "\(Double(self.amount)! * 100)", currency: "SAR")
                                    //Saving Card Data into Keychain
                                    DispatchQueue.main.async {
                                        if let cardName = self.nameField.text,
                                            let cardNumber = self.numberField.text,
                                            let cvv = self.cvvField.text {
                                            do {
                                                try self.keychain.set(string: cardName, forKey: "cardName")
                                                try self.keychain.set(string: cardNumber, forKey: "cardNumber")
                                                try self.keychain.set(string: cvv, forKey: "cvv")
                                                try self.keychain.set(string: self.month, forKey: "month")
                                                try self.keychain.set(string: self.year, forKey: "year")
                                            } catch let keychainError as KeychainError {
                                                print("Could not store credentials in the keychain. \(keychainError)")
                                            } catch {
                                                print(error)
                                            }
                                        }
                                    }
                                }
                            })
                        }
                    }
                }
    }
    
    
    func proceedPayment(token: String, amount: String,currency: String) {
        guard let email = APIManager.sharedInstance.getCustomer()?.email else {
            APIManager.sharedInstance.customPOP(isError: true, message: "Customer email id is missing")
            return
        }
//        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id! else { print("Customer Id is missing" ); return }
        
        var params = [  "autoCapTime"   :   "0",
                        "autoCapture"   :   "Y",
                        "email"         :   email,
                        "value"         :   amount,
                        "currency"      :   currency,
                        "trackId"       :   APIManager.sharedInstance.currentTime(),
                        "cardToken"     :   token
            ] as [String : AnyObject]
        
        if self.isMada {
            params["chargeMode"] = 2 as AnyObject
            params["attemptN3D"] = true as AnyObject
            params["udf1"] = "mada" as AnyObject
            params["successUrl"] = "https://facebook.com" as AnyObject
            params["failUrl"] = "https://google.com.pk" as AnyObject
        }

        let header = ["Content-Type" : "application/json",
                      "Authorization": SECRET_KEY
        ]
        
        WebServiceManager.post(params: params, serviceName: CHECKOUT_PAYMENT_URL,  header: header, serviceType: "Credit Card Payment" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            self.cardTokenButton.isEnabled = true
            if user.responseCode == "10000" {
                if self.isMada {
                    self.redirectView.frame = window.bounds
                    self.redirectView.redirectedUrlId = user.id
                    if let url = NSURL(string: user.redirectUrl!) {
                        let request = NSURLRequest(url: url as URL)
                        self.redirectView.webView.load(request as URLRequest)
                    }
                    window.addSubview(self.redirectView)
                } else {
//                    APIManager.sharedInstance.responseCode = user.responseCode!
                    self.upDateOrderStatus(orderId: self.orderIds)
                }
            } else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.responseMessage ?? ERROR_MESSAGE)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }, showHUD: true)
    }
    
    
    //MARK:- UPDATE ORDER STATUS
    func upDateOrderStatus(orderId: String) {
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
            APIManager.sharedInstance.customPOP(isError: true, message: "Customer email id is missing")
            return
        }
        let language = APIManager.sharedInstance.getLanguage()!.id
        let params = [  "language_id"   :   language,
                        "customer_id"   :   customerId,
                        "orders_id"      :   orderId
            ] as [String : AnyObject]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded" ]
        WebServiceManager.poost(params: params, serviceName: UPDATE_ORDER_STRATUS,  header: header, serviceType: "UPDATA ORDER STATUS" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            if user.message?.lowercased() == "success" {
                
                APIManager.sharedInstance.removeOrderIds(orderId: orderId, controller: self)
                self.showThankyouScreen()

            } else {
                
                var orders = APIManager.sharedInstance.getOrderIds()
                orders?.orderIds?.append(orderId)
                APIManager.sharedInstance.setOrderIds(in: orders ?? updateOrderStatus())
                self.showThankyouScreen()
                
            }
            
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: false)
    }

    func showThankyouScreen()  {
        
        self.view.addSubview(self.thankYouScreen)
        self.thankYouScreen.frame = self.view.bounds
        self.thankYouScreen.setValues(amount: self.amount, deliveryTime:  self.lblDeliveryTime ?? "", firstName: self.firstName ?? "", dayValue: self.day)

    }
    
    private func authenticateWithBiometrics(completion: @escaping (Error?) -> Void) {
        let authenticationContext = LAContext()
        
        var localAuthenticationError: NSError?
        
        if authenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error: &localAuthenticationError),
            localAuthenticationError == nil {
            
            let reason: String
            
            switch authenticationContext.biometryType {
            case .touchID:
                reason = "Fill your last entered values with your Touch ID"
            case .faceID:
                reason = "Fill your last entered values with your Face ID"
            case .none:
                completion(LocalAuthenticationError.biometryNotAvailable)
                return
            }
            
            authenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (success, error) in
                if success {
                    completion(nil)
                } else {
                    if let localError = error {
                        completion(LocalAuthenticationError.forwarded(localError))
                    } else {
                        completion(LocalAuthenticationError.unknown)
                    }
                }
            }
            
        } else {
            if let error = localAuthenticationError {
                completion(LocalAuthenticationError.forwarded(error))
            } else {
                completion(LocalAuthenticationError.unknown)
            }
        }
    }
}

enum LocalAuthenticationError: Error {
    case biometryNotAvailable
    case forwarded(Error)
    case unknown
}
