//
//  QHomeVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 19/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import Cosmos
import Alamofire
import ImageSlideshow
import ObjectMapper
import SVProgressHUD
import MIBadgeButton_Swift


class QHomeVC: UIViewController {
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var catCollectionView: UICollectionView!
    @IBOutlet weak var imgStore: UIImageView!
    @IBOutlet weak var imgBanner: UIImageView!
    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var lblIsCloseColor: UILabel!
    @IBOutlet weak var lblIsClose: UILabel!
    @IBOutlet weak var lblLimit: UILabel!
    @IBOutlet weak var lblTimeSlot: UILabel!
    @IBOutlet weak var lblPriceAndRules: UILabel!
    @IBOutlet weak var txtFindThings: UITextField!
    @IBOutlet weak var noDataAvailable: UIView!
    @IBOutlet weak var btnAddToCart: MIBadgeButton!

    @IBOutlet weak var btnChange: UIButton!
    @IBOutlet weak var lblChangeStore: UILabel!
    
    @IBOutlet weak var lblNodataAvailable: UILabel!
    @IBOutlet weak var lblSubtitleNoData: UILabel!

    let kVersion = "CFBundleShortVersionString"
    
    var mainCategories : CitiesAndAreaModel?
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
//     let productView  : QProductVC = UIViewController.fromNib()
    
    let settingVC : QProductVC = QProductVC(nibName: "QProductVC", bundle: nil)
    let alertView : QAlertView = UIView.fromNib()

    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
//    var storeDate: Results?
    var homePageCategories: [FeaturedProducts]?
    
    var index   : Int!
    var areaId  : String!
    var cityId  : String!
    var bannerHeight:CGFloat = 0
    var banners: [BannerImage]?
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.title = " "
    
        getAppVersion()
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCart), name: NSNotification.Name(rawValue: "getCart"), object: nil)
        
        catCollectionView.register(UINib(nibName: "QCatMenuCell", bundle: nil), forCellWithReuseIdentifier: "QCatMenuCell")
        tableView.register(UINib(nibName: "QProductsCollectionCell", bundle: nil), forCellReuseIdentifier: "QProductsCollectionCell")

        // Do any additional setup after loading the view.

        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 0, right: 15)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal

        alertView.no = {() -> Void in
            self.alertView.removeFromSuperview()
            self.isUpdate = false
        }
        
        alertView.yes = {() -> Void in
            
            //if update  is availabel
            if self.isUpdate {
                
                //Opening app in app store
                UIApplication.shared.open((URL(string: "itms-apps://itunes.apple.com/app/apple-store/" + "id1453159366?ls=1&mt=8")!), options:[:], completionHandler: nil)
                self.alertView.removeFromSuperview()
                self.isUpdate = false
                
            } else {// Switch store
                if let id = APIManager.sharedInstance.getCustomer()?.customer_id {
                    self.emptyCartService(customerId: id)
                } else {
                    self.emptyCartService(customerId: "")
                }
            }
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        localizeStrings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getBanners()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        if let img =  APIManager.sharedInstance.getStore()?.image, let banner =  APIManager.sharedInstance.getStore()?.banner {
            APIManager.sharedInstance.downloadImage(from: img, to: imgStore)
            APIManager.sharedInstance.downloadImage(from: banner, to: imgBanner)
        }
        
        if let status =  APIManager.sharedInstance.getStore()?.store_status {
            if status.lowercased() != "close" {
                lblIsClose.text = "OPEN"
                lblIsCloseColor.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            } else {
                lblIsClose.text = "CLOSED"
                lblIsCloseColor.textColor = #colorLiteral(red: 1, green: 0.1490196078, blue: 0, alpha: 1)
            }
        }
        
        if let name =  APIManager.sharedInstance.getStore()?.firstname , let lastname =  APIManager.sharedInstance.getStore()?.lastname{
            if APIManager.sharedInstance.getLanguage()!.id == "1" {
                lblStoreName.text = name
            } else {
                lblStoreName.text = lastname
            }
        }
        
        if let rating =  APIManager.sharedInstance.getStore()?.rating {
            ratingView.rating = Double(rating)!
        }
        if let minimumOrder =  APIManager.sharedInstance.getStore()?.minimum_order {
            if APIManager.sharedInstance.getLanguage()!.id == "1" {
                lblLimit.text = "Min Limit: \(minimumOrder) SR"
            }else {
                lblLimit.text = " الحد الأدنى\( minimumOrder ) ريال"
            }
        }
        if let timeContent =  APIManager.sharedInstance.getStore()?.time_content {
            lblTimeSlot.text = timeContent
        }
        if let time =  APIManager.sharedInstance.getStore()?.time {
            lblPriceAndRules.text = time
        }
        
        if APIManager.sharedInstance.getLocation().isLocation {
            if let id = APIManager.sharedInstance.getStore()?.seller_id {
                getMianCategories(seller_id: id, type: .Location)
                getFeaturedProducts(seller_id: id)
            }
        } else {
            if let id = APIManager.sharedInstance.getStore()?.seller_id {
                getMianCategories(seller_id: id, type: .Store)
                getFeaturedProducts(seller_id: id)
            }
        }
        
    }
    

    override func viewDidAppear(_ animated: Bool) {
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        layout.itemSize = CGSize(width: (screenWidth/4) - 22, height: self.catCollectionView.frame.height - 3)
        catCollectionView!.collectionViewLayout = layout
        cartCount()
        guard let orderIds = APIManager.sharedInstance.getOrderIds()?.orderIds else {  return }
        
        for ids in orderIds {
            APIManager.sharedInstance.upDateOrderStatus(orderId: ids, isFromOrderHistory: false, controller: self)
        }
    }

    //Localization configrations
    func localizeStrings() {
        btnChange.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "search", comment: ""), for: .normal)
        lblChangeStore.text = LocalizationSystem.shared.localizedStringForKey(key: "change_Store", comment: "")
        txtFindThings.placeholder = LocalizationSystem.shared.localizedStringForKey(key: "Find_your_thing", comment: "")
        lblNodataAvailable.text = LocalizationSystem.shared.localizedStringForKey(key: "Data_not_found", comment: "")
        lblSubtitleNoData.text = LocalizationSystem.shared.localizedStringForKey(key: "there_is_no_data_to_show_you", comment: "")
    }
    
    //Get app version number
    func getAppVersionNumber() -> Double {
        let Dict = Bundle.main.infoDictionary!
        let version = Dict[kVersion] as! String
        return Double(version)!
    }
    
    
    func cartCount() {
        if let customerId = APIManager.sharedInstance.getCustomer()?.customer_id {
            getCartItems(customerId: customerId)
        }else {
            getCartItems(customerId: "")
        }
    }
    
    
    // MARK:- BUTTON ACTIONS
    @IBAction func btnChangeStore(_ sender: Any) {

            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QFavoriteStoreVC") as! QFavoriteStoreVC
            self.navigationController?.pushViewController(vc, animated: true)
//            NotificationCenter.default.post(name: .callHomePage, object: nil)

    }
    @IBAction func btnAddToCart(_ sender: MIBadgeButton) {

        NotificationCenter.default.post(name: .goToCart, object: nil)
    }
    @IBAction func btnChange(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QHomeSearchVC") as! QHomeSearchVC
        vc.searchProducts = self.txtFindThings.text
        self.navigationController?.pushViewController(vc, animated: true)
//        NotificationCenter.default.post(name: .callHomePage, object: nil)
    }
    

}








//MARK:- TABLEVIEW DELEGATE DATASOURCE
extension QHomeVC: UITableViewDelegate , UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.homePageCategories?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "QProductsCollectionCell", for: indexPath) as! QProductsCollectionCell
        cell.collectionView.register(UINib(nibName: "QProductCell", bundle: nil), forCellWithReuseIdentifier: "QProductCell")

        cell.layout.sectionInset = UIEdgeInsets(top:1, left: 15, bottom: 0, right: 15)
        cell.layout.minimumInteritemSpacing = 0
        cell.layout.minimumLineSpacing = 5
        cell.layout.scrollDirection = .horizontal
        cell.layout.scrollDirection = .horizontal
        cell.layout.itemSize = CGSize(width: (screenWidth/3.5), height: (self.screenWidth / 2) - 35 )
        cell.collectionView!.collectionViewLayout = cell.layout
        
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.reloadData()
        cell.collectionView.tag = indexPath.row
        cell.lblname.text = self.homePageCategories?[indexPath.row].name
        
        cell.viewMore = {() -> Void in
            
            if self.homePageCategories?[indexPath.row].name?.lowercased() == "special products"{
                
                NotificationCenter.default.post(name: .callSpecialViewController, object: nil)
                
            } else {
                let viewMoreCategory = MainCatetogries()
                viewMoreCategory.category_id = self.homePageCategories?[indexPath.row].category_id
                viewMoreCategory.name = self.homePageCategories?[indexPath.row].name
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QSubCategoriesVC") as! QSubCategoriesVC
                vc.subCategory = viewMoreCategory
                self.navigationController?.pushViewController(vc, animated: true)
            }      
        }

        self.index =  indexPath.row
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.screenWidth / 2
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        let sliderView: ImageSlideshow  =  ImageSlideshow(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.bannerHeight))
        headerView.addSubview(sliderView)
        if let bannersArray = self.banners {
            sliderView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9843137255, blue: 0.9921568627, alpha: 1)
            sliderView.setBanner2(banners: bannersArray)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.bannerHeight
    }
//    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
//        return 0.01
//    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: CGFloat.leastNormalMagnitude))
        footerView.backgroundColor = .green
        return footerView
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

   
   
}


// MARK:- COLLECTION VIEW DELEGATES
extension QHomeVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == catCollectionView {
            guard let catCount = self.mainCategories?.mainCategories?.count else {
                return 1
            }
            return catCount + 1
        }
        return self.homePageCategories?[collectionView.tag].products?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == catCollectionView {
            // Header   Categories  Cell
            let cell = catCollectionView.dequeueReusableCell(withReuseIdentifier: "QCatMenuCell", for: indexPath) as! QCatMenuCell
                    //All products
            
                    if indexPath.item == 0 {
                        cell.lblCategoryName.text = LocalizationSystem.shared.localizedStringForKey(key: "All", comment: "")
                        cell.imgCategory.image = #imageLiteral(resourceName: "all")
                        return cell
                    }
            
                    let category = self.mainCategories?.mainCategories?[indexPath.item - 1]
                    cell.lblCategoryName.text = category?.name?.withoutHtml
                    cell.imgCategory.loadImage(from: category?.image, isBaseUrl: false)

                    return cell
            
        } else {
            
            // Products     Cell
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QProductCell", for: indexPath) as! QProductCell
            cell.btnAddToCart.isHidden = false

            let product =  self.homePageCategories?[collectionView.tag].products?[indexPath.item]
            cell.lblProductName.text     = product?.name
            
        
        // Downloading image for url
            cell.imgProduct.loadImage(from: product?.image, isBaseUrl: true)

        // Special products with special price
            product?.price = product?.price?.replacingOccurrences(of: " SR", with: "", options: NSString.CompareOptions.literal, range:nil)
            if product?.special != "0" {
                cell.specialConst.constant = cell.frame.width / 2.5
                cell.layoutIfNeeded()
                APIManager.sharedInstance.strikeOnLabel(value: product?.price, label: cell.lblDiscount)
                if let sp = product?.special {
                    let s = Double(sp)!.round(to: 2)
                    cell.lblPrice.text  = "  \(s)"
                    cell.lblPrice.textAlignment = .left
                }
                
                if let special = product?.special ,let price = product?.price {
                    cell.discountSetUp(isDiscount: true, "\(APIManager.sharedInstance.countDiscount(special: special, price: price))")
                }
            } else {
                cell.discountSetUp(isDiscount: false, "")
                cell.specialConst.constant = 0
                cell.lblPrice.text           = product?.price
                cell.lblPrice.textAlignment = .center
            }
            if (Int(product?.quantity ?? "0")!) >= (Int(cell.lblCount.text!)!) {
                cell.isOutOfStock(false)
            } else {
                cell.isOutOfStock(true)
            }
            
//            if product?.in_wishlist == 0 {
//                cell.btnIsFavourite.setImage(#imageLiteral(resourceName: "likeIcon"), for: .normal)
//            } else {
//                cell.btnIsFavourite.setImage(#imageLiteral(resourceName: "likedProduct"), for: .normal)
//            }
        
            cell.minus = {() -> Void in
                self.addToCartMinus(productId: product?.product_id ?? "0", label: cell.lblCount ,index: indexPath.row)
            }
            
            cell.plus = {() -> Void in
                if product?.option_available == 1  {
                    self.movetoProductDetailView(product: product)
                } else {
                    self.addTeCartItemPlus(productId: product?.product_id ?? "0", label: cell.lblCount ,index: indexPath.row)
                }
            }
            return cell
        }
        
    }
 
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == catCollectionView {
            if indexPath.item != 0 {
                if let category = self.mainCategories?.mainCategories?[indexPath.item - 1] {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "QSubCategoriesVC") as! QSubCategoriesVC
                    vc.subCategory = category
                    self.navigationController?.pushViewController(vc, animated: true)
//                    self.navigationController?.navigationBar.isHidden = false
//                    NotificationCenter.default.post(name: .callHomePage, object: nil)
                }
            }
        } else {
            movetoProductDetailView(product: self.homePageCategories?[collectionView.tag].products?[indexPath.item])
        }
        
    }

    
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return CGFloat(5)
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    
            let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            layout?.sectionHeadersPinToVisibleBounds = true
    
            return CGFloat(0)
        }
    
    
    //MARK: - ADD TO CART WITH PLUS AND MINUS ONE

    func addToCartMinus(productId: String, label : UILabel, index : Int) {
        if Int(label.text!)! > 0 {
            label.text = "\(Int(label.text!)! - 1)"
            APIManager.sharedInstance.addToCart(productId: productId, productQuantiy: label.text!)
        }
    }
    func addTeCartItemPlus(productId: String, label : UILabel, index : Int) {
        label.text = "\(Int(label.text!)! + 1)"
        APIManager.sharedInstance.addToCart(productId: productId, productQuantiy: label.text!)
    }
    
    
    func movetoProductDetailView(product: Product?)  {
        settingVC.currentProduct = product
        window.addSubview(settingVC.view)
        settingVC.view.frame = window.bounds
        settingVC.closeProductView = {()-> Void in
            self.settingVC.view.removeFromSuperview()
        }
    }
    
    
}




extension QHomeVC {
    
    // Header categories service
    func getMianCategories(seller_id : String ,type: UrlType) {
        var url = ""
        let language = APIManager.sharedInstance.getLanguage()?.id
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""
//        var areaId = ""
        switch type {
        case .Store:
            if let id = APIManager.sharedInstance.getCityAndArea()?.areaId {
                areaId = id
                url = MAIN_CATEGORIES + "&seller=\(seller_id)&area=\(id)&is_area=1&city_id=\(city_Id)&language=" +  language!
            }
        case .Location:
            
            
            if let lat = APIManager.sharedInstance.getStore()?.latitude, let lng = APIManager.sharedInstance.getStore()?.longitude {
                 let rad = APIManager.sharedInstance.getLocation().radius
                url = GET_CATEGORIES_BY_LOCATION + "language=\(language!)&seller=\(seller_id)&lat=\(lat)&lng=\(lng)&radius=\(rad)&is_area=0&city_id=\(city_Id)"
            }
            
        case .City:
            print("No need")
            break
        case .Area:
            print("No need")
            break
        }
        
        
        let idofAppointmet = [ "": "" ] as [String : AnyObject]
        WebServiceManager.get(params : idofAppointmet, serviceName: url , header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Mian categories", modelType: CitiesAndAreaModel.self, success: { (response) in
            let data = (response as! CitiesAndAreaModel)
            if data.msg?.lowercased() == "success" {
                self.mainCategories = data
                self.catCollectionView.delegate = self
                self.catCollectionView.dataSource = self
                self.catCollectionView.reloadData()
                self.catCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
            }
            
        }) { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
    }
    
    
    func getFeaturedProducts(seller_id : String) {
        WebServiceManager.progressHudSetting()
        SVProgressHUD.show()
        let lang = APIManager.sharedInstance.getLanguage()!.id
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""
        let url = HOME_PAGE_PRODUCTS + "seller_id=\(seller_id)&city_id=\(city_Id)&language_id=" + lang
        Alamofire.request( url , method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                
                if let data = response.result.value{
                    var products = Mapper<FeaturedProducts>().mapArray(JSONObject: data)
                        self.homePageCategories = products
                        self.tableView.delegate = self
                        self.tableView.dataSource = self
                        self.tableView.reloadData()
                   
                    if products?.count != 0 {
                        self.noDataAvailable.isHidden = true
                    }
                }
                break
                
            case .failure(_):
//                APIManager.sharedInstance.customPOP(isError: true, message: ERROR_MESSAGE)
                break
                
            }
            SVProgressHUD.dismiss()
        }
        
    }
    
    
    func getBanners() {

        let url = "https://www.qareeb.com/index.php?route=product/productapi/getbanner"
        Alamofire.request( url , method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let homePageBanners = Mapper<BannerImage>().mapArray(JSONObject: data)
                    if homePageBanners?.count != 0 {
                        self.banners = homePageBanners
                        self.bannerHeight = 105
                        self.noDataAvailable.isHidden = true
                        self.tableView.reloadData()
                    }else {
                        self.bannerHeight = 0
                        self.tableView.reloadData()
                    }
                }
                break
                
            case .failure(_):
                break
            }
        }
    }
    
    
    
    
    func emptyCartService(customerId : String) {
        let params = [  "customer_id" : customerId,
                        "device_id": APIManager.sharedInstance.getIsFirstTime()!.token,
                        "ios"   : "1"
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: EMPTY_CART, header: header, serviceType: "User LogIn" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            if user.msg?.lowercased() == "success" {
                self.alertView.removeFromSuperview()
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "QFavoriteStoreVC") as! QFavoriteStoreVC
                self.navigationController?.pushViewController(vc, animated: true)
                self.navigationController?.navigationBar.isHidden = false
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.msg ?? ERROR_MESSAGE)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }, showHUD: true)
    }
    
    
    
    
    
    //Cart service
    func getCartItems(customerId: String) {
        let token = APIManager.sharedInstance.getIsFirstTime()!.token
        let lang = APIManager.sharedInstance.getLanguage()!.id
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""
        Alamofire.request( GET_CART + "language=" + lang + "&customer_id=\(customerId)&city_id=\(city_Id)&device_id=\(token)", method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let cart = Mapper<SellerResult>().mapArray(JSONObject: data)
//                    charges.reduce(0, { ($0 + $1) })
                    var totalItemsInCart = 0
                    if let cartProducts = cart {
                        for count in cartProducts {
                            totalItemsInCart += count.products?.count ?? 0
                        }
                    }
                    self.btnAddToCart.badgeString = "\(totalItemsInCart)"                   
                    let subCatCart = QSubCategoriesVC()
                    subCatCart.cartButton.badgeString = "\(cart?.count ?? 0)"
                }
                break
            case .failure(_):
                break
                
            }
        }
    }


    func getAppVersion()  {
        let params = [  "" :  "" ] as [String : AnyObject]
        WebServiceManager.get(params : params, serviceName: UPDATE_VERSION, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "UPDATE VERSION PLEASE", modelType: AppVersion.self, success: { (response) in
            let data = (response as! AppVersion)
            guard let version = data.config_android_app_url else {return}
            if self.getAppVersionNumber() < Double(version)! {
                self.isUpdate = true
                window.addSubview(self.alertView)
                self.alertView.frame = window.bounds
                self.alertView.imgWarning.image = #imageLiteral(resourceName: "download-button")
                self.alertView.lblTitle.text = LocalizationSystem.shared.localizedStringForKey(key: "Update", comment: "") + " \(version)"
                self.alertView.lblWarning.text = LocalizationSystem.shared.localizedStringForKey(key: "app_update", comment: "")
            }
            
        }) { (error) in
        }
    }
    
    
    @objc func getCart(_ notification: NSNotification)  {
       cartCount()
    }
    
    
    
}











