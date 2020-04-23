//
//  QCartVc.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 25/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import Kingfisher
import DropDown

class QCartVc: UIViewController , UITextViewDelegate {
    
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var lblSubTotal: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblDeliveryFee: UILabel!
    @IBOutlet weak var lblCreditCouponVoucher: UILabel!
    @IBOutlet weak var lblVat: UILabel!
    @IBOutlet weak var txtComments: UITextViewX!
    
    @IBOutlet weak var headerView: UIViewX!
    @IBOutlet weak var lblHDeliveryFee: UILabel!
    @IBOutlet weak var lblHLImit: UILabel!
    @IBOutlet weak var imgHBarCode: UIImageView!
    @IBOutlet weak var lblMiniLimit: UILabel!
    
    @IBOutlet weak var couponView: UIViewX!
    
    @IBOutlet weak var heightLabel: NSLayoutConstraint!
    
    let logInView : QLoginView = UIView.fromNib()

    
    @IBOutlet weak var btnAppley: UIButton!
    @IBOutlet weak var subTotalLabel: UILabel!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var vatLabel: UILabel!
    @IBOutlet weak var deliveryLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var btnCheckOut: UIButton!
    @IBOutlet weak var txtPlaceHolder: UITextField!
    @IBOutlet weak var lblCoupon: UITextField!
    @IBOutlet weak var lblHStoreName: UILabel!


    let dropDown = DropDown()
    
    var multiSellerCartItems : MultiSellerCart?
    var cartItems: [CartModel]?
    var headerHeight: CGFloat = 60
    
    var coupon = 0.0
    var couponName = "null"
    var subTotal = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeStrings()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        
        tableView.register(UINib(nibName: "QCartCell", bundle: nil), forCellReuseIdentifier: "QCartCell")
        txtComments.delegate = self
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                    guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
                        APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
                        return
                    }
            guard let seller_id = self.multiSellerCartItems?.result?[index].seller_id else {  return }
            self.applyCouponService(customerId: customerId, coupon: self.lblCoupon.text ?? "", sellerId: "\(seller_id)")
                    self.couponName = self.lblCoupon.text ?? "null"
        }

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        guard let storeName = APIManager.sharedInstance.getStore()?.firstname else {print("empty Store"); return }
        guard let storeNameArabic = APIManager.sharedInstance.getStore()?.lastname else {print("empty Store"); return }
        guard let minimumOrder = APIManager.sharedInstance.getStore()?.minimum_order else {print("No limit"); return }
        guard (APIManager.sharedInstance.getStore()?.delivery_charges) != nil else {print("no delivery charges"); return }
        
        if let customerId = APIManager.sharedInstance.getCustomer()?.customer_id {
//                getCartItems(customerId: customerId)
            getMultiSellerCartItems(customerId: customerId)
            
        }else {
//            getCartItems(customerId: "")
            getMultiSellerCartItems(customerId: "")
        }
        
        headerView.frame.size.height = headerHeight
        
        
        if APIManager.sharedInstance.getLanguage()!.id == "1" {
            lblHLImit.text = "Min Limit: \(minimumOrder) SR"
            lblHStoreName.text = storeName
        }else {
            lblHLImit.text = " الحد الأدنى\( minimumOrder ) ريال"
            lblHStoreName.text = storeNameArabic
        }
//        lblHLImit.text = "Min Limit \(minimumOrder) SR"
//        lblHDeliveryFee.text = "\(LocalizationSystem.shared.localizedStringForKey(key: "Delivry_Free", comment: "")) \(deliveryCharges) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
        
//        lblDeliveryFee.text = "\(deliveryCharges) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
        minLimit(minLimit: minimumOrder)
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        //Moving to checkout controller
        APIManager.sharedInstance.logIn = {() -> Void in
            self.moveToCheckOutVC()
        }
        
    }

    
    
    //Localization configrations
    func localizeStrings() {
        //        LocalizationSystem.shared.setLanguage(languageCode: language)
        btnCheckOut.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "CHECK_OUT", comment: ""), for: .normal)
        btnAppley.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "APPLY", comment: ""), for: .normal)
        subTotalLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Sub_Total", comment: "")
        deliveryLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Delivry_Free", comment: "")
        creditCardLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Credit_Coupon", comment: "")
        vatLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "VAT", comment: "")
        lblCoupon.placeholder = LocalizationSystem.shared.localizedStringForKey(key: "Coupon_Code", comment: "")
        txtPlaceHolder.placeholder = LocalizationSystem.shared.localizedStringForKey(key: "Please_enter_your_comments", comment: "")
        totalLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Total", comment: "")
        lblCreditCouponVoucher.text = "0 \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
        title = LocalizationSystem.shared.localizedStringForKey(key: "Cart", comment: "")
    }
    
    
    func minLimit(minLimit: String) {
            self.lblMiniLimit.text = "\(LocalizationSystem.shared.localizedStringForKey(key: "Buy", comment: "")) \(minLimit) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: "")) \(LocalizationSystem.shared.localizedStringForKey(key: "more_and_unlock", comment: ""))"
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        self.txtPlaceHolder.text = " "
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            self.txtPlaceHolder.text = ""
        }else {
            self.txtPlaceHolder.text = " "
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 */
     @IBAction func btnApplyCoupon(_ sender: UIButton) {
    
//        dropDown.anchorView = couponView
//        self.dropDown.bottomOffset = CGPoint(x: 0, y:((couponView.bounds.height)) + CGFloat(3.0))
//        if let storesData = self.multiSellerCartItems?.result?.map({$0.name_En}) {
//                self.dropDown.dataSource = storesData as! [String]
//                self.dropDown.show()
//        }
////
//
        
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
            APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
            return
        }
        guard let seller_id = APIManager.sharedInstance.getStore()?.seller_id else {  return }
        applyCouponService(customerId: customerId, coupon: lblCoupon.text ?? "", sellerId: seller_id)
        self.couponName = self.lblCoupon.text ?? "null"
     }
 
    @IBAction func btnCheckOut(_ sender: Any) {

        if (APIManager.sharedInstance.getCustomer()?.customer_id) != nil {
            moveToCheckOutVC()
        } else {
//            self.view.addSubview(self.logInView)
//            self.logInView.frame = self.view.bounds
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "signinController") as! QSignInVC
            vc.previousVC = self
            vc.modalTransitionStyle = .coverVertical
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        

       
    }
    
    
    func moveToCheckOutVC() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QCheckOutVC") as? QCheckOutVC
        vc?.subTotal = self.subTotal
        vc?.tvComments = self.txtComments.text
        if self.coupon != 0.0 {
            vc?.coupon = self.couponName
        }else {
            vc?.coupon = "null"
        }
        
        vc?.total =  lblTotal.text ?? ""
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    // Calculation sub total
    func subTotal(cart: [CartModel]?) ->  Double {
        var total = 0.0
        if let cartItems = cart {
            for item in cartItems {
                let oneItem = item.price! * Double(item.quantity!)!
                total = total + oneItem
            }
            total = Double(String(format: "%.2f", total))!
        }
        if let minimumOrder =  APIManager.sharedInstance.getStore()?.minimum_order {
            let min = Double(minimumOrder)!
            if (min > total) {
//                self.lblMiniLimit.text = "Buy \(Double(String(format: "%.2f", (min - total)))!) SR more to min limit"
                 self.minLimit(minLimit: "\(Double(String(format: "%.2f", (min - total)))!)")
//                headerView.frame.size.height =
                self.heightLabel.constant = 20
                btnCheckOut.isEnabled = false
                btnCheckOut.backgroundColor = UIColor(named: "lightBlueGrey")
            } else {
                self.heightLabel.constant = 0
                btnCheckOut.isEnabled = true
                btnCheckOut.backgroundColor = UIColor(named: "boringGreen")
            }
        }
        var totalAmount = 0.0
        if let deliveryCharges = APIManager.sharedInstance.getStore()?.delivery_charges {
            totalAmount += Double(deliveryCharges)!
        }else {
            lblDeliveryFee.text = LocalizationSystem.shared.localizedStringForKey(key: "Free", comment: "")
        }
        totalAmount += total
        lblTotal.text = "\(totalAmount) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
        self.subTotal = total - self.coupon
        self.lblVat.text = "\((self.subTotal * (5 / 100)).round(to: 2))"
        self.subTotal = total + self.subTotal * (5 / 100)
        return total
    }
    
    
    // Calculation sub total
    func subTotalMultiCartItems(cart: [SellerResult]?) ->  Double {
        var total = 0.0
        if let cartItems = cart {
            for item in cartItems {
                let oneItem = item.total!
                total = total + oneItem
            }
            total = Double(String(format: "%.2f", total))!
        }

        var totalAmount = 0.0
        
        
        //delivery charges Calculations
        var totalDeliveryCharges = 0
        let dCharges = self.multiSellerCartItems?.result?.compactMap({$0.delivery_charges})
        
        if let charges = dCharges {
            totalDeliveryCharges = charges.reduce(0, { ($0 + $1) })
        }
        
        let d = self.multiSellerCartItems?.result?.filter({
            (Double($0.minimum_order ?? 0) > ($0.total ?? 0.0))
            
        })
        
        if let name = d?.first?.name_En {
            if name == nil {
                btnCheckOut.isEnabled = true
                btnCheckOut.backgroundColor = UIColor(named: "boringGreen")
            }else {
                btnCheckOut.isEnabled = false
                btnCheckOut.backgroundColor = UIColor(named: "lightBlueGrey")
            }
        }else {
            btnCheckOut.isEnabled = true
            btnCheckOut.backgroundColor = UIColor(named: "boringGreen")
        }
        
        
        //Checking is there any store have delivey fee
        if totalDeliveryCharges != 0 {
            totalAmount += Double(totalDeliveryCharges)
            lblDeliveryFee.text = "\(totalDeliveryCharges) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
        }else {
            //if store hasn't delivery charges
            lblDeliveryFee.text = LocalizationSystem.shared.localizedStringForKey(key: "Free", comment: "")
        }
        
        totalAmount += total
        lblTotal.text = "\(totalAmount) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
        self.subTotal = total - self.coupon
        self.lblVat.text = "\((self.subTotal * (5 / 100)).round(to: 2))"
        self.subTotal = total + self.subTotal * (5 / 100)
        return total
    }
    
    func isMinimumOrderLimitReached() -> Bool {
        return true
    }
}


extension QCartVc : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.multiSellerCartItems?.result?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.multiSellerCartItems?.result?[section].products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QCartCell", for: indexPath) as! QCartCell
        let item = self.multiSellerCartItems?.result?[indexPath.section].products?[indexPath.row]

        cell.lblName.text = item?.name
        cell.lblPrice.text = "\(item?.price ?? 0.0) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
        cell.lblQuantity.text = item?.quantity
            
        if item?.special != 0 {
            cell.layoutIfNeeded()
            APIManager.sharedInstance.strikeOnLabel(value: "\(item?.price ?? 0.0)", label: cell.lblSpecial)
            if let sp = item?.special {
                let s = Double(sp).round(to: 2)
                cell.lblPrice.text  = "  \(s) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
                cell.lblPrice.textAlignment = .center
                cell.specialView.isHidden = false
                cell.lblSpecial.isHidden = false
            }
        } else {

            cell.lblPrice.text  = "\(item?.price ?? 0.0)"
            cell.lblPrice.textAlignment = .center
            cell.specialView.isHidden = true
            cell.lblSpecial.isHidden = true
        }

        if let url =  item?.image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
            cell.imgProduct.kf.setImage(with: resource, placeholder: UIImage(named: IMAGE_PLACEHOLDER), options: [.transition(ImageTransition.fade(1))], progressBlock: { (recievedSize, totalSize) in
                //                print((1 / totalSize) * 100)
            }, completionHandler: nil)
        }


        cell.minum = {() -> Void in
            self.updateCartItemMinus(cartId: item?.cart_id ?? "0", quantity: item?.quantity ?? "0", label: cell.lblQuantity ,index: indexPath.row)
        }

        cell.plus = {() -> Void in
            if item?.stock == true {
                self.updateCartItemPlus(cartId: item?.cart_id ?? "0", quantity: item?.quantity ?? "0", label: cell.lblQuantity, index: indexPath.row)
            }
        }
        
        cell.delete = {() -> Void in
            self.removeFromCart(cartId: (item?.cart_id!)!)
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Custom header view for multiple stores
        
        let header = Bundle.main.loadNibNamed("QHeaderCell", owner: self, options: nil)?.last as! QHeaderCell
        
        let sectionItem = self.multiSellerCartItems?.result?[section]
    
        
        header.lblTotalItems.text = "\(LocalizationSystem.shared.localizedStringForKey(key: "items", comment: "")) \(sectionItem?.products?.count ?? 0) \t \(LocalizationSystem.shared.localizedStringForKey(key: "Total", comment: "")) : \(sectionItem?.total ?? 0.0)"
        
        if Int(sectionItem?.total ?? 0) <=  (sectionItem?.free_delivery_order_limit ?? 0) {
            sectionItem?.delivery_charges = 0
        }
        
        //English language
        if APIManager.sharedInstance.getLanguage()?.id == "1" {
            header.lblStoreName.text = sectionItem?.name_En
            header.lblLImit.text = "Min Limit: \(sectionItem?.minimum_order ?? 0) SR"
            
            header.lblDeliveryFee.text = "Delivery fee \(sectionItem?.delivery_charges ?? 0) SR"
        }else {
            // Arabic languate
            header.lblStoreName.text = sectionItem?.name_Ar
            header.lblLImit.text = " الحد الأدنى \( sectionItem?.minimum_order ?? 0 ) ريال"
            header.lblDeliveryFee.text = "\(LocalizationSystem.shared.localizedStringForKey(key: "Delivry_Free", comment: "")) \(sectionItem?.delivery_charges ?? 0) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
        }

        return header

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.width / 3.3
    }
    
    
    func updateCartItemPlus(cartId: String, quantity: String , label : UILabel, index : Int) {
        label.text = "\(Int(label.text!)! + 1)"
        self.cartItems?[index].quantity = label.text
        self.lblSubTotal.text = "\(self.subTotal(cart: self.cartItems)) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
        updateCartItem(cartId: cartId, quantity: label.text!)
    }
    
    func updateCartItemMinus(cartId: String, quantity: String , label : UILabel, index : Int) {
        if Int(label.text!)! > 1 {
            label.text = "\(Int(label.text!)! - 1)"
            self.cartItems?[index].quantity = label.text
            self.lblSubTotal.text = "\(self.subTotal(cart: self.cartItems)) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
            updateCartItem(cartId: cartId, quantity: label.text!)
        }
    }
    
    
    
    func applyCouponService(customerId: String, coupon: String, sellerId: String) {
        let params = [  "customer_id"   : customerId,
                        "coupon"        : coupon,
                        "seller_id"     : sellerId,
                        "language_id"   : APIManager.sharedInstance.getLanguage()!.id,
                        "device_id"     : APIManager.sharedInstance.getIsFirstTime()!.token,
                        "ios"           : "1"
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: APPLY_COUPON, header: header, serviceType: "APPLY COUPON" , modelType: CouponModel.self, success: { (response) in
            let coupon = (response as! CouponModel)
            if coupon.msg == "success" {
                if let result = coupon.result?.first {
                    self.coupon += result.value ?? 0.0
                    self.lblCreditCouponVoucher.text = "\(self.coupon.round(to: 2)) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
                    self.lblTotal.text = "\((self.subTotalMultiCartItems(cart: self.multiSellerCartItems?.result) - self.coupon).round(to: 2)) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
                } else {
                    APIManager.sharedInstance.customPOP(isError: true, message: coupon.resultMsg?.msg ?? "Invalid Coupon")
                }
            }
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }, showHUD: true)
    }
    
    
    //Cart service
        func getCartItems(customerId: String) {
            WebServiceManager.progressHudSetting()
            SVProgressHUD.show()
            
            let lang = APIManager.sharedInstance.getLanguage()! .id
            let token = APIManager.sharedInstance.getIsFirstTime()!.token
            let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""

            Alamofire.request( GET_CART + "language=" + lang + "&customer_id=\(customerId)&city_id=\(city_Id)&device_id=\(token)", method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                SVProgressHUD.dismiss()
                switch(response.result) {
                case .success(_):
                    if let data = response.result.value{
                        
                        let cart = Mapper<CartModel>().mapArray(JSONObject: data)
                        self.cartItems = cart
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.lblSubTotal.text = "\(self.subTotal(cart: self.cartItems)) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
                        self.tableView.reloadData()
                        
                    }
                    break
                case .failure(_):
                    APIManager.sharedInstance.customPOP(isError: true, message: response.result.error?.localizedDescription ?? ERROR_MESSAGE)
                    break
                }
            }
        }
    
    //Cart service
    func getMultiSellerCartItems(customerId: String) {
        WebServiceManager.progressHudSetting()
        SVProgressHUD.show()
        
        let lang = APIManager.sharedInstance.getLanguage()! .id
        let token = APIManager.sharedInstance.getIsFirstTime()!.token
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""


        let params = [  "" :  "" ] as [String : AnyObject]
        let url = "https://www.qareeb.com/index2.php?route=product/productapi/getCartNew&customer_id=\(customerId)&device_id=\(token)&city_id=\(city_Id)&language=" + lang
        
        WebServiceManager.get(params : params, serviceName: url, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Mian categories", modelType: MultiSellerCart.self, success: { (response) in
            let data = (response as! MultiSellerCart)
//            if data.msg?.lowercased() == "success" {
            
                self.multiSellerCartItems = data
                self.tableView.delegate = self
                self.tableView.dataSource = self
                self.tableView.reloadData()
                
                self.lblSubTotal.text = "\(self.subTotalMultiCartItems(cart: data.result)) \(LocalizationSystem.shared.localizedStringForKey(key: "SAR", comment: ""))"
            if data.result ==  nil {
                self.btnCheckOut.isEnabled = false
                self.btnCheckOut.backgroundColor = UIColor(named: "lightBlueGrey")
            }
            
//            }else {
//                   APIManager.sharedInstance.customPOP(isError: true, message: data.resultMsg ?? ERROR_MESSAGE)
//            }
            
        }) { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
        
        
        
        
    }
    
    
    
    
    
    
    // MARK: - REMOVE PRODUCT FROM CART SERVICE
    func removeFromCart(cartId: String) {
        let params = [  "cart_id"   : cartId,
                        "ios"       : "1"
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: REMOVE_FROM_CART, header: header, serviceType: "REMOVE FROM CART" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            debugPrint(user)
            if user.msg == "success" {
                APIManager.sharedInstance.customPOP(isError: false, message: user.result ?? "Successfully removed")
                if let customerId = APIManager.sharedInstance.getCustomer()?.customer_id {
                    self.getMultiSellerCartItems(customerId: customerId)
                }else {
                    self.getMultiSellerCartItems(customerId: "")
                }
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.msg ?? ERROR_MESSAGE)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
    
    // MARK: - REMOVE PRODUCT FROM CART SERVICE
    func updateCartItem(cartId: String ,quantity: String) {
        
        let params = [  "cart_id"           : cartId,
                        "product_quantity"  : quantity,
                        "ios"               : "1"
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: UPDATE_CART_ITEM, header: header, serviceType: "UPDATE CART ITEM" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            debugPrint(user)
            if user.msg == "success" {
                APIManager.sharedInstance.customPOP(isError: false, message: user.result ?? "Successfully  updated")
                if let customerId = APIManager.sharedInstance.getCustomer()?.customer_id {
                    self.getMultiSellerCartItems(customerId: customerId)
                }else {
                    self.getMultiSellerCartItems(customerId: "")
                }
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.msg ?? ERROR_MESSAGE)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
}
