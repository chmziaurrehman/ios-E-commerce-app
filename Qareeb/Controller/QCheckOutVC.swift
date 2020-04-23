//  QCheckOutVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 26/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import ObjectMapper
import SVProgressHUD

class QCheckOutVC: UIViewController {
    
    enum PaymentMethod: String {
        case COD
        case CARD
        case BANK
    }
    
    var payment_code = "cod"
    
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var deliverySlotLabel: UILabel!
    @IBOutlet weak var paymentMethodLabel: UILabel!
    @IBOutlet weak var btnAddNewAddress: UIButton!
    @IBOutlet weak var btnSelectDeliveryTime: UIButton!
    @IBOutlet weak var btnProceedToPayment: UIButton!
    
    @IBOutlet weak var nowView: UIViewX!
    @IBOutlet weak var scheduleView: UIViewX!
    @IBOutlet weak var bankAccountView: UIViewX!
    @IBOutlet weak var btnNow: UIButton!
    @IBOutlet weak var btnSchedual: UIButton!
    
    @IBOutlet weak var lblBankTransferInstruction: UILabel!
    @IBOutlet weak var lblFollowingBankAccount: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblBankName: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblIBAN: UILabel!
    @IBOutlet weak var lblOrderWillShip: UILabel!
    
    var paymentMethod = PaymentMethod.COD
    
    let alertView : QAddNewAddress = UIView.fromNib()
    let timeSlots : QTimeSlotsByDays = UIView.fromNib()
    let thankYouScreen : QOrderPlaced = UIView.fromNib()
    let datePickerView : MDVDatePicker = UIView.fromNib()
    
    var addresses : AddressModel?
    
    let paymentMethods = [LocalizationSystem.shared.localizedStringForKey(key: "Cash_On_Delivery", comment: ""),LocalizationSystem.shared.localizedStringForKey(key: "Credit_Debit_Card", comment: ""),LocalizationSystem.shared.localizedStringForKey(key: "Bank_Transfer", comment: "")]
    
    var daysSlots: [Slots]?
    var slotsByDay: [String]?
    var timeSlotsModel : AddressModel?
    var selectedAddress: AddressResults?
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    let dropDown = DropDown()
    
    var tvComments = ""
    var subTotal = 0.0
    var total = ""
    var vat = 0.0
    var address = ""
    var timeSlot = ""
    var day = ""
    var countryCode = "184"
    var city = ""
    var coupon: String!
    var orderIds: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIManager.sharedInstance.maxAndMinDate { (max, min) in
            datePickerView.datePicker.maximumDate = min
            datePickerView.datePicker.minimumDate = max
            datePickerView.datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        }
        
        
        lblPaymentMethod.text = LocalizationSystem.shared.localizedStringForKey(key: "Cash_On_Delivery", comment: "")
        localizeStrings()

        self.vat = subTotal * (5 / 100)
        
        if APIManager.sharedInstance.getStore() == nil {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please select a store")
        } else {
//            print(APIManager.sharedInstance.getStore()!)
        }
        
        
        tableView.register(UINib(nibName: "QAddressCell", bundle: nil), forCellReuseIdentifier: "QAddressCell")
        timeSlots.collectionView.register(UINib(nibName: "QSlotsByDaysCell", bundle: nil), forCellWithReuseIdentifier: "QSlotsByDaysCell")
        timeSlots.slotTableView.register(UINib(nibName: "QTimeSlotCell", bundle: nil), forCellReuseIdentifier: "QTimeSlotCell")

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 0, right: 15)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: (screenWidth/7), height: self.timeSlots.collectionView!.frame.height / 1.2)
        timeSlots.collectionView!.collectionViewLayout = layout
        
        
  
        // Do any additional setup after loading the view.
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else { return }
        
        alertView.addAddress = {() -> Void in
            self.addNewAddresses(fname: self.alertView.lblfirstname.text!, lname: self.alertView.lblLastName.text!, address: self.alertView.lblAddress.text!, city: self.alertView.lblCity.text!, customerId: customerId, countryId: "184")
        }
        getAddresses(customerId: customerId)
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            self.lblPaymentMethod.text = item
            if APIManager.sharedInstance.responseCode == "10000" {
                APIManager.sharedInstance.customPOP(isError: true, message: "You have an incomplete order please Click on Proceed button for order completion")
                self.paymentMethod = PaymentMethod.CARD
                self.payment_code = "credit or debit cart"
            } else {
                switch index {
                case 0:
                    self.paymentMethod = PaymentMethod.COD
                    self.payment_code = "cod"
                    self.bankAccountView.isHidden = true
                case 1:
                    self.paymentMethod = PaymentMethod.CARD
                    self.payment_code = "credit_or_debit_cart"
                    self.bankAccountView.isHidden = true
                case 2:
                    self.paymentMethod = PaymentMethod.BANK
                    self.payment_code = "bank_transfer"
                    self.bankAccountView.isHidden = false
                default:
                    break
                }
            }
      
        }
        self.thankYouScreen.dismissView  = {() -> Void in
             self.thankYouScreen.removeFromSuperview()
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QTabbarNavigationController") as! QTabbarNavigationController
//            self.present(vc, animated: true, completion: nil)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "QTabbarNavigationController") as! QTabbarNavigationController
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
       
    }
    override func viewWillAppear(_ animated: Bool) {
//        if APIManager.sharedInstance.responseCode == "10000" {
//            paymentGateWayVerification()
//        }
    }
    
    
    
    //Localization configrations
    func localizeStrings() {
        
        lblBankTransferInstruction.text = LocalizationSystem.shared.localizedStringForKey(key: "BANK_TRANSFER_INSTRUCTION", comment: "")
        lblFollowingBankAccount.text  = LocalizationSystem.shared.localizedStringForKey(key: "Please_transfer_the_total_amount", comment: "")
        lblTitle.text  = LocalizationSystem.shared.localizedStringForKey(key: "Account_title", comment: "")
        lblBankName.text  = LocalizationSystem.shared.localizedStringForKey(key: "Bank_Name_National_Commercial_Bank", comment: "")
        lblAccountNumber.text  = LocalizationSystem.shared.localizedStringForKey(key: "Account_Number", comment: "")
        lblIBAN.text  = LocalizationSystem.shared.localizedStringForKey(key: "IBAN_No", comment: "")
        lblOrderWillShip.text  = LocalizationSystem.shared.localizedStringForKey(key: "Your_order_will_not_ship", comment: "")
        
        
         btnNow.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "now", comment: ""), for: .normal)
         btnSchedual.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "schedule", comment: ""), for: .normal)
        
        btnProceedToPayment.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "proceed_to_payment", comment: ""), for: .normal)
        btnAddNewAddress.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Add_New_Address", comment: ""), for: .normal)
        btnSelectDeliveryTime.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Select_Delivery_Time", comment: ""), for: .normal)
        addressLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Address", comment: "")
        deliverySlotLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Please_Select_delivery_slot", comment: "")
        paymentMethodLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Payment_Method", comment: "")
        lblDeliveryTime.text = LocalizationSystem.shared.localizedStringForKey(key: "Delivery_slot_not_available", comment: "")
        title = LocalizationSystem.shared.localizedStringForKey(key: "CHECK_OUT", comment: "")
    }


    @objc func dateChanged(_ sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy hh:mm a"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        lblDeliveryTime.text = formatter.string(from: datePickerView.datePicker.date)
    }
    
    
    
    @IBAction func btnDeliveryTime(_ sender: UIButton) {
        if sender.tag == 0 {
            nowView.backgroundColor = UIColor(named: "boringGreen")
            scheduleView.backgroundColor = .white
            getTimeSlots()
        }else {
            nowView.backgroundColor = .white
            scheduleView.backgroundColor = UIColor(named: "boringGreen")
            view.addSubview(datePickerView)
            datePickerView.frame = view.bounds
        }
        
    }
    @IBAction func btnAddNewAddress(_ sender: Any) {
        window.addSubview(self.alertView)
        self.alertView.frame = window.bounds
    }
    @IBAction func btnSelectDeliveryTime(_ sender: Any) {
//        getDaysSlots(sellerId: "34")
        window.addSubview(self.timeSlots)
        self.timeSlots.frame = window.bounds
    }
    
    @IBAction func btnPaymentMethod(_ sender: UIButton) {
        dropDown.anchorView = sender
        self.dropDown.bottomOffset = CGPoint(x: 0, y:(self.dropDown.anchorView?.plainView.bounds.height)!)
        self.dropDown.dataSource = paymentMethods
        self.dropDown.show()
    }
    @IBAction func btnProceedToPayment(_ sender: Any) {
        if self.lblDeliveryTime.text == LocalizationSystem.shared.localizedStringForKey(key: "Delivery_slot_not_available", comment: "") {
            APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "Select_Delivery_Time", comment: ""))
        } else {
            paymentGateWayVerification()
        }
    }
    
    func paymentGateWayVerification() {
        switch paymentMethod {
        case .COD:
            placeAnOrder()
        case .CARD:
//            if APIManager.sharedInstance.responseCode == "10000" {
                placeAnOrder()
//            } else {
//                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QCheckOutPaymentVC") as! QCheckOutPaymentVC
//                vc.amount = self.total.replacingOccurrences(of: " " + LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""), with: "", options: NSString.CompareOptions.literal, range:nil)
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//
        case .BANK:
            placeAnOrder()
            
        }
    }
    
    func placeAnOrder() {
        
        
        guard let deliveryCharges = APIManager.sharedInstance.getStore()?.delivery_charges else { print("Delivery charges is missing" ); return }
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id! else { print("Customer Id is missing" ); return }
        let languageId = APIManager.sharedInstance.getLanguage()!.id
        let deviceId = APIManager.sharedInstance.getIsFirstTime()!.token
        
        //Calling place order service
        placeOrder(customerId: customerId, deviceId: deviceId, paymentMethod: self.lblPaymentMethod.text!, payment_code: payment_code, shippingZone: self.selectedAddress?.zone_id ?? "", countryCode: self.selectedAddress?.country_id ?? "", firstname: self.selectedAddress?.firstname ?? "", lastname: self.selectedAddress?.lastname ?? "", address1: self.address , city: self.selectedAddress?.city ?? "", order_comments: tvComments, delivery_time: lblDeliveryTime.text ?? "", language_id: languageId, vatValue: "\(self.vat)", deliveryCharges: deliveryCharges)
    }
    
    
}


extension QCheckOutVC : UITableViewDelegate, UITableViewDataSource , UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == timeSlots.slotTableView {
            return self.slotsByDay?.count ?? 0
        }
        return self.addresses?.result?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == timeSlots.slotTableView {
            let cellSlot = tableView.dequeueReusableCell(withIdentifier: "QTimeSlotCell", for: indexPath) as! QTimeSlotCell
                cellSlot.lblTimeSlot.text = self.slotsByDay?[indexPath.row]
            return cellSlot
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "QAddressCell", for: indexPath) as! QAddressCell
            cell.lbAddress.text = self.addresses?.result?[indexPath.row].address_1?.capitalized
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == timeSlots.slotTableView {
            lblDeliveryTime.text = self.day + "  " + (self.slotsByDay?[indexPath.row])!
            self.timeSlot = self.timeSlotsModel?.timeSlotsWithDats?[indexPath.row] ?? ""
        } else {
            self.address = self.addresses?.result?[indexPath.row].address_1?.capitalized ?? ""
            self.selectedAddress = self.addresses?.result?[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 50
    }
    
    
// Collection view delegate and data source methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.daysSlots?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QSlotsByDaysCell", for: indexPath) as! QSlotsByDaysCell
            cell.lblDay.text = self.daysSlots?[indexPath.item].name
            cell.lblDate.text = self.daysSlots?[indexPath.item].date
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let date = self.daysSlots?[indexPath.item].date {
            guard let _ = APIManager.sharedInstance.getStore()?.seller_id else { print("customer id missing"); return }
            self.day = date
//            getTimeSlots(sellerId: sellerId, day: date)
        }
    }
    
    
    
    // MARK:- WEB SERVICES
// Get list of all address
    func getAddresses(customerId: String) {
        let idofAppointmet = [ "": "" ] as [String : AnyObject]
        let url = GET_ADDRESS + customerId
    
        WebServiceManager.get(params : idofAppointmet, serviceName: url, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Forgot Password", modelType: AddressModel.self, success: { (response) in
            let data = (response as! AddressModel)
            if data.msg?.lowercased() == "success" {
             self.addresses  = data
                if data.result?.count != 0 {
                    self.tableView.delegate     = self
                    self.tableView.dataSource   = self
                    self.tableView.reloadData()
                    self.tableView.selectRow(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .none)
                    self.address = self.addresses?.result?[0].address_1?.capitalized ?? ""
                    self.selectedAddress = self.addresses?.result?[0]
                }
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
            }
            
        }) { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
    }

    
    func getTimeSlots() {
        let idofAppointmet = [ "": "" ] as [String : AnyObject]
        let languageId = APIManager.sharedInstance.getLanguage()!.id
        let customerId = APIManager.sharedInstance.getCustomer()?.customer_id!
        let  url = NEXT_DELIVERY_SLOT + "customer_id=\(customerId ?? "0")&language=\(languageId)"

        WebServiceManager.get(params : idofAppointmet, serviceName: url, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "GET NEXT DELIVERY SLOT", modelType: AddressModel.self, success: { (response) in
            let deliverySlot = (response as! AddressModel)
            self.lblDeliveryTime.text = deliverySlot.slot
        }) { (error) in
        }
    }
    
    
// Add new address service
    func addNewAddresses(fname:String,lname:String,address:String,city:String,customerId:String,countryId:String) {
        let url = ADD_ADDRESS
        let language = APIManager.sharedInstance.getLanguage()!.id
        let params = [  "firstname"     : fname,
                        "lastname"      : lname,
                        "address"       : address,
                        "city"          : city,
                        "customerid"    : customerId,
                        "language_id"   : language,
                        "country_id"    : countryId
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: url, header: header, serviceType: "User LogIn" , modelType: AddressModel.self, success: { (response) in
            let address = (response as! AddressModel)
            if address.address_id != nil {
                self.alertView.removeFromSuperview()
                guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
                    APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""), comment: ""))
                    return
                }
                self.getAddresses(customerId: customerId)
            } else {
                APIManager.sharedInstance.customPOP(isError: true, message: address.error ?? ERROR_MESSAGE)
            }
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }, showHUD: true)
     
    }
    
 
    // Add new address service
    func placeOrder(customerId :String, deviceId: String, paymentMethod:String, payment_code: String, shippingZone:String, countryCode:String, firstname:String, lastname:String, address1:String, city: String, order_comments:String, delivery_time:String, language_id:String, vatValue: String, deliveryCharges:String) {
        var url: String!
        let params =  ["customer_id": customerId ,
                       "device_id": deviceId,
                       "payment_method": paymentMethod,
                       "payment_code": payment_code,
                       "gift_wrapping": "undefined",
                       "input-shipping-zone": shippingZone,
                       "input-shipping-country": countryCode,
                       "input-shipping-firstname": firstname,
                       "input-shipping-lastname": lastname,
                       "input-shipping-company": "",
                       "input-shipping-address-1": address1,
                       "input-shipping-address-2": "",
                       "input-shipping-city": city,
                       "input-shipping-postcode": "",
                       "shipping_method": "Delivery time upto 24-48 hrs.",
                       "shipping_code": "flat.flat",
                       "input-default-address": "undefined",
                       "order_comments": order_comments,
                       "delivery_time": delivery_time,
                       "coupon": self.coupon,
//                       "seller_id": seller_id,
                       "language_id": language_id,
                       "vat_text": "Value Added Tax (5%25)",
                       "vat_value": vatValue,
                       "dc_text": "Delivery Charges",
                       "dc_value": deliveryCharges
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        if self.paymentMethod == .CARD {
            url = PLACE_ORDER_PANDING_PAYMENT
        } else {
            url = PLACE_ORDER_MultiStore
        }
        
        WebServiceManager.poost(params: params, serviceName: url, header: header, serviceType: "Place Order" , modelType: ConfirmOrder.self, success: { (response) in
            let order = (response as! ConfirmOrder)
            if order.message == true {
                guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id! else { print("Customer Id is missing" ); return }
                switch self.paymentMethod {
                case .CARD:
                    guard let orderIds = order.orderid else { return }
                        self.orderIds = orderIds
//                    self.emptyCart(customerId: customerId, orderId: "\(order.orderid ?? "")", total: order.total ?? 0.0)

                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QCheckOutPaymentVC") as! QCheckOutPaymentVC
                        self.total = self.total.replacingOccurrences(of: " SR", with: "", options: NSString.CompareOptions.literal, range:nil)
                        self.total = self.total.replacingOccurrences(of: " ريال ", with: "", options: NSString.CompareOptions.literal, range:nil)
                        vc.amount = self.total
                        vc.orderIds = orderIds
                        self.navigationController?.pushViewController(vc, animated: true)
                case .BANK,.COD:
                    self.emptyCart(customerId: customerId, orderId: "\(order.orderid ?? "")", total: order.total ?? 0.0)
                }
                APIManager.sharedInstance.responseCode = ""
            } else {
                APIManager.sharedInstance.customPOP(isError: true, message: order.msg ?? ERROR_MESSAGE)
            }
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }, showHUD: true)
        
    }
    

    func emptyCart(customerId: String, orderId: String, total: Double) {

        let url = EMPTY_CART
   
        let params = [ "customer_id" : customerId ]
        
        Alamofire.request(url, method:.post, parameters: params, encoding: URLEncoding.default).validate().responseJSON {
            response in
            switch response.result {
            case .failure( _):
                
                window.addSubview(self.thankYouScreen)
                self.thankYouScreen.frame = window.bounds
                self.thankYouScreen.setValues(amount: "\(total)", deliveryTime:  self.lblDeliveryTime.text ?? "", firstName: self.selectedAddress?.firstname ?? "", dayValue: self.day)

            case .success( _):
                if response.result.value != nil {
                    window.addSubview(self.thankYouScreen)
                    self.thankYouScreen.frame = window.bounds
                    self.thankYouScreen.setValues(amount: "\(total)", deliveryTime:  self.lblDeliveryTime.text ?? "", firstName: self.selectedAddress?.firstname ?? "", dayValue: self.day)

                } else {
                    APIManager.sharedInstance.customPOP(isError: true, message: ERROR_MESSAGE)
                }
                
            }
        }
    }
    
    
    
    
    
    
    
}
