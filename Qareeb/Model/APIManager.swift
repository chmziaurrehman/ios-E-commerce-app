//
//  APIManager.swift
//  PakArmy
//
//  Created by M Zia Ur Rehman Ch. on 27/07/2017.
//  Copyright © 2017 M Zia Ur Rehman Ch. All rights reserved.
//


import Foundation
import CoreData
import UIKit
import ObjectMapper
import UserNotifications
import CoreLocation
import Kingfisher
import GoogleMaps
import GoogleSignIn


let sta =  UIViewX()
let window = UIApplication.shared.keyWindow!
var screenWidth: CGFloat!
var screenHeight: CGFloat!

class APIManager {
    static let sharedInstance = APIManager()
    let mainWindow = UIApplication.shared.keyWindow
//    var lang: String!
    private init(){
    }
    
    var languageId = "1"
    var product: Product?
    var storeInfo : Results?
    
    let userDefaults = UserDefaults.standard
    let inConst :CGFloat   = 16
    let outConst:CGFloat   = 50
    var responseCode = ""
    var currentAddressCallback:((String)-> Void)?

    var logIn:(()-> Void)!
    
    var countryList = [Country]()

    var popViewController:(()-> Void)?
    
    var countries: [String] = {
        
        var arrayOfCountries: [String] = []
        
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"


            arrayOfCountries.append(name)
        }
        var sortedArray = arrayOfCountries.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        return sortedArray
    }()
    
    
    //MARK:- USER DEFAULTS SETUP
    
    func setStore( in store: Store)  {
        UserDefaults.standard.set(encodable: store, forKey: "Store")
    }
    func getStore() -> Store? {
        if let store = UserDefaults.standard.value(Store.self, forKey: "Store") {
            return store
        }else {
            return Store()
        }
    }
    func setCityAndArea( in store: CityAndArea)  {
        UserDefaults.standard.set(encodable: store, forKey: "CityAndArea")
    }
    func getCityAndArea() -> CityAndArea? {
        if let cityAndArea = UserDefaults.standard.value(CityAndArea.self, forKey: "CityAndArea") {
            return cityAndArea
        }else {
            return CityAndArea()
        }
    }
    func setCustomer( in customer: Customer)  {
        UserDefaults.standard.set(encodable: customer, forKey: "Customer")
    }
    func getCustomer() -> Customer? {
        if let customer = UserDefaults.standard.value(Customer.self, forKey: "Customer") {
            return customer
        }else {
            return Customer()
        }
    }
    func setLanguage( in language: Languages)  {
        UserDefaults.standard.set(encodable: language, forKey: "Languages")
    }
    func getLanguage() -> Languages? {
        if let lang = UserDefaults.standard.value(Languages.self, forKey: "Languages") {
            return lang
        }else {
            return Languages()
        }
    }
    
    
    
    func setOrderIds( in order: updateOrderStatus)  {
        UserDefaults.standard.set(encodable: order, forKey: "order")
    }
    func getOrderIds() -> updateOrderStatus? {
        if let order = UserDefaults.standard.value(updateOrderStatus.self, forKey: "order") {
            return order
        } else {
            return updateOrderStatus()
        }
    }
    
    
    func setIsFirstTime( in isfirsttime: IsFirstTime)  {
        UserDefaults.standard.set(encodable: isfirsttime, forKey: "IsFirstTime")
    }
    func getIsFirstTime() -> IsFirstTime? {
        if let isfirsttime = UserDefaults.standard.value(IsFirstTime.self, forKey: "IsFirstTime") {
            return isfirsttime
        }else {
            return IsFirstTime()
        }
    }
    
    
    func setLocation( in location: StoreByLocation)  {
        UserDefaults.standard.set(encodable: location, forKey: "StoreByLocation")
    }
    func getLocation() -> StoreByLocation {
        if let location = UserDefaults.standard.value(StoreByLocation.self, forKey: "StoreByLocation") {
            return location
        }else {
            return StoreByLocation()
        }
    }
    
    func countryNamesByCode() -> [Country] {
        
        var countries = [Country]()
        let frameworkBundle = Bundle(for: AGCountryCodeView.self)
        
        guard let jsonPath = frameworkBundle.path(forResource: "Countries", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return countries
        }
        
        do {
            countries = try JSONDecoder().decode([Country].self, from: jsonData)
        } catch {
            print("Error parsing the countries json")
        }
        return countries
    }
    
    
    
    //Discout counter
    func countDiscount(special: String?, price: String?) -> Int {
        if let special = special ,let price = price {
            let s = Double(special)!
            let p = Double(price)!
            let disPrice = 100 - ((s / p ) * 100)
            return Int(disPrice)
        }
        return 0
    }

    
    
    // Share products
    func shareProduct(imageUrl: String? , _ controller :UIViewController)  {
        if let imgUrl = imageUrl {
            let items = [URL(string: imgUrl.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!]
            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
            controller.present(ac, animated: true)
        }else {
            APIManager.sharedInstance.customPOP(isError: true, message: "Something went wrong try again")
        }
        
    }
    
    
    // MARK: - GETTING  ADDRESS
    func getAddress(currentAdd : @escaping ( _ returnAddress :String)->Void){
        
        let geocoder = GMSGeocoder()
        let coordinate = CLLocationCoordinate2DMake(APIManager.sharedInstance.getLocation().latitude, APIManager.sharedInstance.getLocation().lngitude)

        
        var currentAddress = String()
        
        geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
            if let address = response?.firstResult() {
                let lines = address.lines! as [String]
                
                currentAddress = lines.joined(separator: ",")
                currentAdd(currentAddress)
            }
        }
    }
    
    // MARK: - GETTING CURRENT ADDRESS
    func getCurrentAddress(currentAdd : @escaping ( _ returnAddress :String) ->Void) {

            let geocoder = GMSGeocoder()
            let coordinate = CLLocationCoordinate2DMake(CURRENT_DEVICE_LAT, CURRENT_DEVICE_LONG)
            var currentAddress = String()
            
            geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
                if let address = response?.firstResult() {
                    let lines = address.lines! as [String]
                    currentAddress = lines.joined(separator: ",")
                    currentAdd(currentAddress)
                }
            }
    }
    
    
    func userCurrentAddress(result: @escaping (_ latitude: Double , _ longitude: Double) -> Void)  {
        _ =  Location.getLocation(withAccuracy:.house, frequency: .significant, onSuccess: { [weak self] location in
            
            result(location.coordinate.latitude, location.coordinate.longitude)
            
            }, onError: { (last, error) in
                print("Something bad has occurred \(error)")
        })
    }
    
    
    
    func gettingLatLong(currentLL : @escaping ( _ lat : Double , _ long : Double)->Void) {
        _ =  Location.getLocation(withAccuracy:.any, frequency: .significant, onSuccess: { [weak self] location in
            currentLL(location.coordinate.latitude,location.coordinate.longitude )
            
            }, onError: { (last, error) in
                print("Something bad has occurred \(error)")
        })
    }
    
    
    
    // MARK: - GETTING  ADDRESS
    func getAddressByCallBack(lat: Double , long: Double) {
        
            let geocoder = GMSGeocoder()
            let coordinate = CLLocationCoordinate2DMake(lat, long)

            
            geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
                if let address = response?.firstResult() {
                    let lines = address.lines! as [String]
                    let city = address.locality! as String
                    self.currentAddressCallback?(lines.joined(separator: ","))
                   print(city)
                }
            }
    }
    
    func userCurrentAddress()  {
        _ =  Location.getLocation(withAccuracy:.any, frequency: .oneShot, onSuccess: { [weak self] location in
            
            self!.getAddressByCallBack(lat: location.coordinate.latitude,long: location.coordinate.longitude)
            
            }, onError: { (last, error) in
                print("Something bad has occurred \(error)")
        })
    }
    
    
    
    
    // MARK: - ADD TO CART PRODUCT SERVICE
    func addToCart(productId: String, productQuantiy: String) {
        var customerId: String?
        if let id = APIManager.sharedInstance.getCustomer()?.customer_id{
            customerId = id
        }
        
        let token = APIManager.sharedInstance.getIsFirstTime()!.token
        let lang = APIManager.sharedInstance.getLanguage()!.id
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""

        guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else { return }
        let params = [  "product_id"        : productId,
                        "product_quantity"  : productQuantiy,
                        "customer_id"       : customerId,
                        "seller_id"         : sellerId,
                        "device_id"         : token,
                        "language_id"       : lang,
                        "city_id"           : city_Id,
                        "ios"               : "1"
            ] as [String : AnyObject]
        
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: ADD_TO_CART, header: header, serviceType: "Add to cart" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            debugPrint(user)
            if user.msg == "success" {
                APIManager.sharedInstance.customPOP(isError: false, message: LocalizationSystem.shared.localizedStringForKey(key: "Added_to_cart", comment: "")) 
                NotificationCenter.default.post(name: .getCart, object: nil)
                //                self.navigationController?.pushViewController(vc!, animated: true)
            } else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.msg ?? ERROR_MESSAGE)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
    
    
    // MARK: - ADD TO CART PRODUCT SERVICE
    func addToCartWithOption(productId: String, productQuantiy: String, optionsValues : [String : AnyObject] ) {
        var customerId: String?
        if let id = APIManager.sharedInstance.getCustomer()?.customer_id {
            customerId = id
        }
        
        let token = APIManager.sharedInstance.getIsFirstTime()!.token
        let lang = APIManager.sharedInstance.getLanguage()!.id
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""
        
        guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else { return }
        var params = [  "product_id"        : productId,
                        "product_quantity"  : productQuantiy,
                        "customer_id"       : customerId,
                        "seller_id"         : sellerId,
                        "device_id"         : token,
                        "language_id"       : lang,
                        "city_id"           : city_Id,
                        "ios"               : "1"
            ] as [String : AnyObject]
        
        params = params.merge(dict: optionsValues)
        
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: ADD_TO_CART_WITH_OPTION, header: header, serviceType: "Add to cart" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            debugPrint(user)
            if user.msg == "success" {
                
                APIManager.sharedInstance.customPOP(isError: false, message: LocalizationSystem.shared.localizedStringForKey(key: "Added_to_cart", comment: ""))
                NotificationCenter.default.post(name: .getCart, object: nil)
                //                self.navigationController?.pushViewController(vc!, animated: true)
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.msg ?? ERROR_MESSAGE)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
    
    //SIGN IN SERVICE
    
    
    func loginUserService(email: String, password: String , controller: UIViewController,previousVC : UIViewController?, isSocial: Bool, gData: GIDGoogleUser? , fData : Any?) {
        var url = SOCIALMEDIA_LOGIN
        var params = [  "email"         : email
            ] as [String : AnyObject]
        if !isSocial {
            params["password"] = password as AnyObject
            url = LOGIN
        }
        params["mobile_reg_id"] = APIManager.sharedInstance.getIsFirstTime()!.token as AnyObject
        params["mobile_user_id"] = APIManager.sharedInstance.getIsFirstTime()!.token as AnyObject
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: url, header: header, serviceType: "User LogIn" , modelType: UserModel.self, success: { (response) in
            let user = (response as! UserModel)
            debugPrint(user)
            if user.message == "success" {
                var customer = APIManager.sharedInstance.getCustomer()
                customer?.customer_id = user.customer_info?.customer_id
                customer?.customer_group_id = user.customer_info?.customer_group_id
                customer?.store_id = user.customer_info?.store_id
                customer?.firstname = user.customer_info?.firstname
                customer?.lastname = user.customer_info?.lastname
                customer?.email = user.customer_info?.email
                customer?.telephone = user.customer_info?.telephone
                customer?.fax = user.customer_info?.fax
                customer?.password = user.customer_info?.password
                customer?.salt = user.customer_info?.salt
                customer?.newsletter = user.customer_info?.newsletter
                customer?.address_id = user.customer_info?.address_id
                customer?.custom_field = user.customer_info?.custom_field
                customer?.ip = user.customer_info?.ip
                customer?.status = user.customer_info?.status
                customer?.approved = user.customer_info?.approved
                customer?.safe  = user.customer_info?.safe
                customer?.token = user.customer_info?.token
                customer?.date_added = user.customer_info?.date_added
                customer?.code = user.customer_info?.code
                customer?.mobile_user_id = user.customer_info?.mobile_user_id
                customer?.mobile_reg_id = user.customer_info?.mobile_reg_id
                APIManager.sharedInstance.setCustomer(in: customer ?? Customer())
                
                if let preVC = previousVC {
                    controller.navigationController?.popToViewController(preVC, animated: false)
                    self.logIn()
                } else {
                    let vc = controller.storyboard?.instantiateViewController(withIdentifier: "QTabbarNavigationController") as! QTabbarNavigationController
                    window.rootViewController = vc
                    window.makeKeyAndVisible()
                }
               
            } else {
                if isSocial {
//                    APIManager.sharedInstance.customPOP(isError: true, message: user.result ?? ERROR_MESSAGE)
                    let vc = controller.storyboard?.instantiateViewController(withIdentifier: "QSignUpVC") as! QSignUpVC
                    vc.googleData = gData
                    vc.faceBookData = fData
                    controller.navigationController?.pushViewController(vc, animated: true)
                } else {
                    APIManager.sharedInstance.customPOP(isError: true, message: user.message ?? ERROR_MESSAGE)
                }
                
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
    
    func loginUserServicePopUp(email: String, password: String , controller: UIViewController, loginView: UIView, closure: @escaping (Bool) -> Void) {
        let params = [  "email"         : email,
                        "password"      : password
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: LOGIN, header: header, serviceType: "User LogIn" , modelType: UserModel.self, success: { (response) in
            let user = (response as! UserModel)
            debugPrint(user)
            if user.message == "success" {
                var customer = APIManager.sharedInstance.getCustomer()
                customer?.customer_id = user.customer_info?.customer_id
                customer?.customer_group_id = user.customer_info?.customer_group_id
                customer?.store_id = user.customer_info?.store_id
                customer?.firstname = user.customer_info?.firstname
                customer?.lastname = user.customer_info?.lastname
                customer?.email = user.customer_info?.email
                customer?.telephone = user.customer_info?.telephone
                customer?.fax = user.customer_info?.fax
                customer?.password = user.customer_info?.password
                customer?.salt = user.customer_info?.salt
                customer?.newsletter = user.customer_info?.newsletter
                customer?.address_id = user.customer_info?.address_id
                customer?.custom_field = user.customer_info?.custom_field
                customer?.ip = user.customer_info?.ip
                customer?.status = user.customer_info?.status
                customer?.approved = user.customer_info?.approved
                customer?.safe  = user.customer_info?.safe
                customer?.token = user.customer_info?.token
                customer?.date_added = user.customer_info?.date_added
                customer?.code = user.customer_info?.code
                customer?.mobile_user_id = user.customer_info?.mobile_user_id
                customer?.mobile_reg_id = user.customer_info?.mobile_reg_id
                APIManager.sharedInstance.setCustomer(in: customer ?? Customer())
                loginView.removeFromSuperview()
                closure(true)
                //                self.navigationController?.pushViewController(vc!, animated: true)
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.message ?? ERROR_MESSAGE)
                closure(false)
                
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
            closure(false)
        }, showHUD: true)
    }
    
    //MARK:- UPDATE ORDER STATUS
    func upDateOrderStatus(orderId: String,isFromOrderHistory: Bool, controller: UIViewController) {
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
                
                self.removeOrderIds(orderId: orderId, controller: controller)
                self.popViewController?()
                
            } else {
                
                var orders = APIManager.sharedInstance.getOrderIds()
                orders?.orderIds?.append(orderId)
                self.setOrderIds(in: orders ?? updateOrderStatus())
                let vc = controller.storyboard?.instantiateViewController(withIdentifier: "QTabbarNavigationController") as! QTabbarNavigationController
                controller.present(vc, animated: true, completion: nil)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: false)
    }
    
    
    func removeOrderIds(orderId:String, controller: UIViewController)  {
        for i in 0..<(getOrderIds()?.orderIds?.count ?? 0) {
            if getOrderIds()?.orderIds![i] == orderId {
                var order = getOrderIds()
                order?.orderIds?.remove(at: i)
                setOrderIds(in: order ?? updateOrderStatus())
            }
        }
    }
    
    
    //MARK:- DOWNLOAD IMAGE FORM URL
    
    func downloadImage(from  url: String? , to  imageView : UIImageView) {
        if let url =  url?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            let resource = ImageResource(downloadURL:  URL(string: url)!, cacheKey: url)
            imageView.kf.setImage(with: resource, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { (recievedSize, totalSize) in
//                print((1 / totalSize) * 100)
            }, completionHandler: nil)
        }
    }

     //MARK : - custom Funcation


    func randomString(length: Int) -> String {

        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)

        var randomString = ""

        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }

        return randomString
    }
    
    
    
    func strikeOnLabel(value : String?, label : UILabel){
        var price = 0.0
        if let val = value {
            price = Double(val)!
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .currency
        currencyFormatter.currencyCode = " SR"
        let priceInINR = currencyFormatter.string(from: price as NSNumber)
        
        let attributedString = NSMutableAttributedString(string: priceInINR!)
        
        // Swift 4.2 and above
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        
        // Swift 4.1 and below
        attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length))
        label.attributedText = attributedString
    }


    func animateRadioButton(button : UIView)  {
        UIView.animate(withDuration: 0.15, animations: {
            button.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }, completion: { _ in
            UIView.animate(withDuration: 0.15) {
                button.transform = CGAffineTransform.identity
            }
        })
    }
    
    func rippleAffect(bacgroundView: UIView) {
        let view = UIViewX(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        view.center = bacgroundView.center
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.4972877358)
        bacgroundView.addSubview(view)
        
        UIViewX.animate(withDuration: 0.4, animations: {
            view.transform = CGAffineTransform(scaleX: 500, y: 500)
            view.alpha = 0
        }) { (true) in
            view.removeFromSuperview()
        }
    }
    

    func generateDates(startDate :Date?, addbyUnit:Calendar.Component, value : Int) -> Date {
        
        let date = startDate!
        let endDate = Calendar.current.date(byAdding: addbyUnit, value: value, to: date)!
        return endDate
    }

//    
//    func getLoggedInUser() -> SKUser? {
//        var user: SKUser? = nil
//        if let userDict = APIManager.getUserDefault(key: SKUserDefaultKeys.LOGGED_IN_USER) as? [String: AnyObject] {
//            user = SKUser(JSON: userDict)
//        }
//        return user
//    }
//    
    func currentTime() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "dd-MM-yyyy hh:mm a"
        let time = dateFormatter.string(from: date)
        return "\(time)"
    }

    func maxAndMinDate(completion: (Date,Date) -> Void) {
        let currentDate = Date()
        var dateComponents = DateComponents()
        let calendar = Calendar.init(identifier: .gregorian)
        let maxDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = 150
        let minDate = calendar.date(byAdding: dateComponents, to: currentDate)
        completion(maxDate!,minDate!)
    }

    

    func customAlertView(viewcontroller: UIViewController, message: String, title: String) {

        let attributedString = NSAttributedString(string: title, attributes: [
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15), //your font here
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.007843137255, green: 0.6039215686, blue: 0.7960784314, alpha: 1)
            ])
        let alert = UIAlertController(title: "Alert", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
        alert.setValue(attributedString, forKey: "attributedTitle")
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        alert.view.tintColor = #colorLiteral(red: 0.007843137255, green: 0.6039215686, blue: 0.7960784314, alpha: 1)
        viewcontroller.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func saveStoreData(notification: StoreDefauls)  {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: notification)
        userDefaults.set(encodedData, forKey: "storeData")
        userDefaults.synchronize()
    }
    
    func getStoreData() -> StoreDefauls? {
        let notification : StoreDefauls? = nil
        if let decoded  = userDefaults.object(forKey: "storeData") as? Data  {
            let decodedTeams = NSKeyedUnarchiver.unarchiveObject(with: decoded) as! StoreDefauls
            return decodedTeams
        }
        return notification
    }

//
    func customAlert(viewcontroller: UIViewController, message: String) {
        
        DispatchQueue.main.async {
       
            let attributedString = NSAttributedString(string: "Vitals", attributes: [
                NSAttributedString.Key.font :UIFont (
                    name: "Montserrat-Regular",
                    size: 14.0)!, //your font here//
                //            NSAttributedStringKey.foregroundColor : #colorLiteral(red: 0.007843137255, green: 0.6039215686, blue: 0.7960784314, alpha: 1)
                ])
            let alert = UIAlertController(title: "Alert", message: "\(message)", preferredStyle: UIAlertController.Style.alert)
            alert.setValue(attributedString, forKey: "attributedTitle")
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            alert.view.tintColor = #colorLiteral(red: 0, green: 0.5416094661, blue: 0.7650926709, alpha: 1)
            viewcontroller.present(alert, animated: true, completion: nil)
            
        }
    }

    func intValue(value : String) -> Double {
        return Double(value)!
    }
    
    var orange      = #colorLiteral(red: 1, green: 0.4976287839, blue: 0.1515687307, alpha: 1)
    var red         = #colorLiteral(red: 0.7502914276, green: 0.2431372549, blue: 0.2705882353, alpha: 1)
    var green       = #colorLiteral(red: 0.3019607843, green: 0.568714132, blue: 0.2823529412, alpha: 1)
    var yellow      = #colorLiteral(red: 0.9529411765, green: 0.8499954308, blue: 0.5599745269, alpha: 1)
    var aquaBlue    = #colorLiteral(red: 0.2549019608, green: 0.7529411765, blue: 0.7137254902, alpha: 1)
    
    var firstColor      = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
    var secondColor     = #colorLiteral(red: 0.5195595026, green: 0.6906707883, blue: 0.2630706429, alpha: 1)
    var textColor       = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    var themeColor      = #colorLiteral(red: 0, green: 0.5416094661, blue: 0.7650926709, alpha: 1)
    
    
    func keyboardType(_ textfield : UITextField , _ isNumber : Bool) {
        if isNumber {
            textfield.keyboardType = .asciiCapableNumberPad
        }else {
            textfield.keyboardType = .asciiCapable
        }
    }
    
    func customPOP(isError : Bool, message: String) {
        
        DispatchQueue.main.async {
            if isError {
                self.firstColor = #colorLiteral(red: 0.7502914276, green: 0.2431372549, blue: 0.2705882353, alpha: 1)
                self.secondColor = #colorLiteral(red: 0.7502914276, green: 0.2431372549, blue: 0.2705882353, alpha: 1)
            }else {
                self.firstColor    = #colorLiteral(red: 0.1913756367, green: 0.568714132, blue: 0.1865123203, alpha: 1)
                self.secondColor   = #colorLiteral(red: 0.3019607843, green: 0.568714132, blue: 0.2823529412, alpha: 1)
            }
            let window = UIApplication.shared.keyWindow
            let popView = UIViewX()
            let popLabel = UILabelX()
            
            popLabel.frame = CGRect(x: 0, y: 0, width: (window?.frame.width)! - 40, height: 0)
            popView.frame = CGRect(x: 20, y: (window?.frame.height)! / 1.25, width: (window?.frame.width)! - 40, height: 0)
            popView.firstColor = APIManager.sharedInstance.firstColor
            popView.secondColor = APIManager.sharedInstance.secondColor
            popView.horizontalGradient = false
            popView.shadowOpacity = 1
            popView.shadowRadius = 5
            popView.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            popLabel.textColor = APIManager.sharedInstance.textColor
            popLabel.textAlignment = .center
            popLabel.font = UIFont(name: "Montserrat-SemiBold", size: 12 )
            popLabel.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            popLabel.numberOfLines = 2
            popLabel.text = message

            UIApplication.shared.keyWindow?.addSubview(popView)
            popView.addSubview(popLabel)
            popView.layoutIfNeeded()

            popView.cornerRadius = 40
            popView.clipsToBounds = true

//            popView.alpha = 1
            popLabel.addTextSpacing(val: 1.0)
//            UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.statusBar
            UIView.animate(withDuration: 0.2, delay: 0, options: [.curveEaseInOut], animations: {
                popView.frame.size.height =  40
                popLabel.frame.size.height = 40
            }) { (true) in
                UIViewX.animate(withDuration: 0.3, delay: 2, options: [.curveEaseOut], animations: {
//                    popView.frame.size.height = 0
                    popLabel.alpha = 0
                }, completion: { (true) in
                    popView.removeFromSuperview()
//                    UIApplication.shared.keyWindow?.windowLevel = UIWindow.Level.normal
                })
            }
            
        }
        
    }

    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
    
    
    

    
}




extension Date {
    func compareTo(date: Date, toGranularity: Calendar.Component ) -> ComparisonResult  {
        var cal = Calendar.current
        cal.timeZone = TimeZone(identifier: "Europe/Paris")!
        return cal.compare(self, to: date, toGranularity: toGranularity)
    }
}








