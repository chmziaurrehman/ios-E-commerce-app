//
//  QSubCategoriesVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 23/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import ObjectMapper
import SVProgressHUD
import MIBadgeButton_Swift

class QSubCategoriesVC: UIViewController , UIScrollViewDelegate{

    @IBOutlet weak var lblStoreName: UILabel!
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var productCollectionView: UICollectionView!
    @IBOutlet weak var catCollectionView: UICollectionView!
    
    @IBOutlet weak var lblNodataAvailable: UILabel!
    @IBOutlet weak var lblSubtitleNoData: UILabel!
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    let layout2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var subCategory: MainCatetogries?
    var mainCategories : [MainCatetogries]?
    var subCatProducts : [[Product]]?
//    var storeDate: Results?
    var startIndex = 0
    
    let settingVC : QProductVC = QProductVC(nibName: "QProductVC", bundle: nil)

    var page:Int = 0
    var isLoadMore: Bool = false
    var isSearch = SearchBy.Id
    let cartButton = MIBadgeButton(type: .custom)
    
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        localizeStrings()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCart), name: NSNotification.Name(rawValue: "getCart"), object: nil)
        
        catCollectionView.register(UINib(nibName: "QCatMenuCell", bundle: nil), forCellWithReuseIdentifier: "QCatMenuCell")
        productCollectionView.register(UINib(nibName: "QProductCell", bundle: nil), forCellWithReuseIdentifier: "QProductCell")
    
        productCollectionView.register(UINib(nibName: "QStoreHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "QStoreHeaderCell")
        catCollectionView.register(UINib(nibName: "QStoreHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "QStoreHeaderCell")
        // Do any additional setup after loading the view.
        
        // RIGHT NAVIGATION BAR BUTTON TO ACCESS CART VIEW
        
        
        cartButton.setImage(UIImage(named: "addToCartIcon"), for: .normal)
        cartButton.addTarget(self, action: #selector(openCart), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
        
        //Getting store name
        guard let arabicName = APIManager.sharedInstance.getStore()?.lastname else { return }
        guard let storeName = APIManager.sharedInstance.getStore()?.firstname else { return }
        
        var name = ""
        if APIManager.sharedInstance.getLanguage()?.id == "1" {
            name = storeName
        } else {
            name = arabicName
//            "yourAreShoppingFrom"
        }
        //Attributed Strings for store name label
        let attrs1 = [NSAttributedString.Key.font : UIFont(name: "Montserrat-Bold", size: 12), NSAttributedString.Key.foregroundColor : UIColor(named: "sunflower_yellow")]
        let attributedString1 = NSMutableAttributedString(string: name, attributes:attrs1 as [NSAttributedString.Key : Any])
        //Second string
        let attrs2 = [NSAttributedString.Key.font : UIFont(name: "Montserrat-Regular", size: 12), NSAttributedString.Key.foregroundColor : UIColor.white]
        let attributedString2 = NSMutableAttributedString(string: " \(LocalizationSystem.shared.localizedStringForKey(key: "yourAreShoppingFrom", comment: "")) ", attributes:attrs2 as [NSAttributedString.Key : Any])
        //Appending string 1 into 2
        attributedString2.append(attributedString1)
        self.lblStoreName.attributedText = attributedString2
        getCategoriesByLocationAndArea()
        setupCollectionViews()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        NotificationCenter.default.post(name: .getCart, object: nil)
    }

    
    func setupCollectionViews() {
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 0, right: 15)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        catCollectionView!.collectionViewLayout = layout
        
        
        layout2.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        layout2.scrollDirection = .vertical
        productCollectionView!.collectionViewLayout = layout2
    }
    
    
    //Localization configrations
    func localizeStrings() {
//        LocalizationSystem.shared.setLanguage(languageCode: language)
        btnSearch.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "search", comment: ""), for: .normal)
//        lblChangeStore.text = LocalizationSystem.shared.localizedStringForKey(key: "change_Store", comment: "")
        txtSearch.placeholder = LocalizationSystem.shared.localizedStringForKey(key: "Find_your_thing", comment: "")
        lblNodataAvailable.text = LocalizationSystem.shared.localizedStringForKey(key: "Data_not_found", comment: "")
        lblSubtitleNoData.text = LocalizationSystem.shared.localizedStringForKey(key: "there_is_no_data_to_show_you", comment: "")
    }
    
    // Open cart button action fuction
    @objc func openCart() -> Void {
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QCartVc") as? QCartVc
//        self.navigationController?.pushViewController(vc!, animated: true)
//        self.navigationController?.navigationBar.isHidden = false
         NotificationCenter.default.post(name: .goToCart, object: nil)
    }
    
    // Getting categories by location and by area
    func getCategoriesByLocationAndArea() {
        if APIManager.sharedInstance.getLocation().isLocation {
            getSubCategoriesProductsByLocation(subCategory)
        }else {
            getSubCategoriesProducts(subCategory)
        }
    }
    
    //Getting category products by area and by location
    func getproductsByCateIdAndByLacationAndArea(by category: MainCatetogries? ) {
        if APIManager.sharedInstance.getLocation().isLocation {
            // Getting products by cat id and by location
            getProductsLoc(by: category)
        }else {
            //Getting products by category Id and By Area id
            getProductss(by: category)
        }
    }
    
    // Get sub cat products by Category id and Area id
    func getSubCategoriesProducts(_ category : MainCatetogries?) {
        if let category = category {
            title = category.name
            guard let id = category.category_id else {  return }
            self.id = id
            guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else {  return }
            guard let areaId = APIManager.sharedInstance.getCityAndArea()?.areaId else {  return }
            getMianCategories(categoryId: id, sellerId: sellerId, areaId: areaId, type: .Store)
            getSubCatProducts(sellerId: sellerId, catId: id, areaId: areaId, searchBy: .Id, type: .Store, startIndex: 0)
        }
    }
    
    //Get Sub category products by location
    func getSubCategoriesProductsByLocation(_ category : MainCatetogries?) {
        if let category = category {
            title = category.name
            guard let id = category.category_id else {  return }
            guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else {  return }
            self.id = id
            getMianCategories(categoryId: id, sellerId: sellerId, areaId: "", type: .Location)
            getSubCatProducts(sellerId: sellerId, catId: id,areaId: "", searchBy: .Id, type: .Location, startIndex: 0)
        }
    }
    
    //Get products by cat and Area id
    func getProductss( by CatId: MainCatetogries? ) {
        if let category = CatId {
            title = category.name
            guard let id = category.category_id else {  return }
            guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else {  return }
            guard let areaId = APIManager.sharedInstance.getCityAndArea()?.areaId else {  return }
            getSubCatProducts(sellerId: sellerId, catId: id, areaId: areaId, searchBy: .Id, type: .Store, startIndex: 0)
        }
    }
    //Get products by cat id and by location
    func getProductsLoc( by CatId: MainCatetogries? ) {
        if let category = CatId {
            title = category.name
            guard let id = category.category_id else {  return }
            guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else {  return }
            getSubCatProducts(sellerId: sellerId, catId: id, areaId: "", searchBy: .Id, type: .Location, startIndex: 0)
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
    @IBAction func btnChange(_ sender: Any) {
        self.view.endEditing(true)
        self.isSearch = SearchBy.Name
        self.subCatProducts?.removeAll()
        self.productCollectionView.reloadData()
        getProductsByName(index: 0)
        
    }
    
    
    func getProductsByName(index : Int) {
        guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else {  return }
        
        if self.txtSearch.text != "" {
            if APIManager.sharedInstance.getLocation().isLocation {
                getSubCatProducts(sellerId: sellerId, catId: self.txtSearch.text! ,areaId: "", searchBy: .Name, type: .Store, startIndex: index)

            }else {
                guard let areaId = APIManager.sharedInstance.getCityAndArea()?.areaId else {  return }
                getSubCatProducts(sellerId: sellerId, catId: self.txtSearch.text! , areaId: areaId, searchBy: .Name, type: .Store, startIndex: index)
            }
        }
    }
    
    
}




// MARK:- COLLECTION VIEW DELEGATES
extension QSubCategoriesVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == catCollectionView {
            guard let catCount = self.mainCategories?.count else {
                return 1
            }
            return catCount + 1
        } else {
            return self.subCatProducts?.count ?? 0
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == catCollectionView {
            let cell = catCollectionView.dequeueReusableCell(withReuseIdentifier: "QCatMenuCell", for: indexPath) as! QCatMenuCell
            if indexPath.item == 0 {
                cell.lblCategoryName.text = LocalizationSystem.shared.localizedStringForKey(key: "All", comment: "")
                cell.imgCategory.image = #imageLiteral(resourceName: "all")
                return cell
            }
            let category = self.mainCategories?[indexPath.item - 1]
            
            cell.lblCategoryName.text = category?.name?.withoutHtml
            cell.imgCategory.loadImage(from: category?.image, isBaseUrl: false)
       
            return cell
        } else {
            let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "QProductCell", for: indexPath) as! QProductCell
            if  let product = self.subCatProducts?[indexPath.item].first {
                
                    cell.lblProductName.text = product.name
                    cell.imgProduct.loadImage(from: product.image, isBaseUrl: true)

                // Special products with special price
//                product.price = product.price?.replacingOccurrences(of: " SR", with: "", options: NSString.CompareOptions.literal, range:nil)
                if product.specialNew != nil {
                    cell.specialConst.constant = cell.frame.width / 2.5
                    cell.layoutIfNeeded()
                    APIManager.sharedInstance.strikeOnLabel(value: "\(product.priceNew ?? 0.0)", label: cell.lblDiscount)
                    if let sp = product.specialNew {
                        let s = sp.round(to: 2)
                        cell.lblPrice.text  = "  \(s)"
                        cell.lblPrice.textAlignment = .left
                    }
                    
                    if let special = product.specialNew ,let price = product.priceNew {
                        cell.discountSetUp(isDiscount: true, "\(APIManager.sharedInstance.countDiscount(special: "\(special)", price: "\(price)"))")
                    }
                } else {
                    cell.discountSetUp(isDiscount: false, "")
                    cell.specialConst.constant = 0
                    cell.lblPrice.text           = "\(product.priceNew ?? 0.0)"
                    cell.lblPrice.textAlignment = .center
                }
                
                if (Int(product.quantity ?? "0")!) >= (Int(cell.lblCount.text!)!) {
                    cell.isOutOfStock(false)
                } else {
                    cell.isOutOfStock(true)
                }

                cell.btnAddToCart.isHidden = false
                
                cell.minus = {() -> Void in
                    self.addToCartMinus(productId: "\(product.productId ?? 00)", label: cell.lblCount ,index: indexPath.row)
                }
                
                cell.plus = {() -> Void in
                    
                    if product.option_available == 1 {
                        self.movetoProductDetailView(product: product)
                    } else {
                        self.addTeCartItemPlus(productId: "\(product.productId ?? 00)", label: cell.lblCount ,index: indexPath.row)
                    }
                }
            }
            return cell
        }
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.isSearch = SearchBy.Id
        if collectionView == catCollectionView {
            self.subCatProducts?.removeAll()
            self.productCollectionView.reloadData()
            if indexPath.item == 0 {
                getCategoriesByLocationAndArea()
            } else {
                if let isTotal = self.mainCategories?[indexPath.item - 1].total_child  {
                    if isTotal != "0" {
                        self.subCategory = self.mainCategories?[indexPath.item - 1]
                        getCategoriesByLocationAndArea()
                        print(isTotal)
                    } else {
                         getproductsByCateIdAndByLacationAndArea(by:  self.mainCategories?[indexPath.item - 1])
                    }
                } else {
                    getproductsByCateIdAndByLacationAndArea(by:  self.mainCategories?[indexPath.item - 1])
                }
            }
        } else if collectionView == productCollectionView {
            if let product = self.subCatProducts?[indexPath.item].first {
              movetoProductDetailView(product: product)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width
        if collectionView == catCollectionView {
          return CGSize(width: (width / 4) - 22, height: self.catCollectionView.frame.height - 3)
        } else {
          return CGSize(width: (width / 3) - 13, height: self.view.frame.height / 4)
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

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
     
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "QStoreHeaderCell", for: indexPath) as! QStoreHeaderCell
   
            if collectionView == productCollectionView  {
                if !self.isLoadMore {
                    if let count = self.subCatProducts?.count {
                        
                        if count >= 9 {
                            
                            if isSearch == SearchBy.Name {
                                getProductsByName(index: count)
                            }else {
                                getProductByPagination(startIndex: count )
                            }
                            
                            self.isLoadMore = true
                        }
                        
                
                    }else {
                        if isSearch == SearchBy.Name {
                            getProductsByName(index: 0)
                        }else {
                            getProductByPagination(startIndex: 0)
                        }
                        self.isLoadMore = true
                    }
                   
                }
            }
           
            
            print("\n\n\nfooter\n\n\n")
            reusableview.clipsToBounds = true
            return reusableview
            
            
        default:  fatalError("Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 0.001, height: 0.001)
    }
    
    func movetoProductDetailView(product: Product)  {
        var newProduct : Product?
        newProduct = product
        newProduct?.product_id  = "\(product.productId ?? 0)"
        newProduct?.price       = "\(product.priceNew ?? 0)"
        if let special = product.specialNew {
            newProduct?.special = "\(special)"
        }
        newProduct?.quantity    = "\(product.quantityInt ?? 0)"
        
        settingVC.currentProduct = newProduct
        
        window.addSubview(settingVC.view)
        //        productVC.didMove(toParent: self)
        settingVC.view.frame = window.bounds
        settingVC.closeProductView = {()-> Void in
            self.settingVC.view.removeFromSuperview()
        }
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
 
    // Header categories service
    func getMianCategories(categoryId : String ,sellerId: String, areaId: String, type: UrlType) {

        guard let languageId = APIManager.sharedInstance.getLanguage()?.id else { return }
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""

        var url = ""
        if type == .Store {
            
             url = SUB_CATEGORIES + "category_id=\(categoryId)&language=\(languageId)&seller=\(sellerId)&area=\(areaId)&city_id=\(city_Id)&is_area=1"
        }else {
            url = GET_SUB_CATEGORIES_BY_LOCATION + "category_id=\(categoryId)&language=\(languageId)&seller=\(sellerId)&lat=\(APIManager.sharedInstance.getLocation().latitude)&lng=\(APIManager.sharedInstance.getLocation().lngitude)&radius=\(APIManager.sharedInstance.getLocation().radius)&city_id=\(city_Id)&is_area=0"
        }
        
        WebServiceManager.progressHudSetting()
        SVProgressHUD.show()
        Alamofire.request(url, method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            SVProgressHUD.dismiss()
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let categories = Mapper<MainCatetogries>().mapArray(JSONObject: data)
//                    if categories?.count != 0 {
                        self.mainCategories = categories
                        self.catCollectionView.delegate = self
                        self.catCollectionView.dataSource = self
                        self.catCollectionView.reloadData()
                        self.catCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)

//                    }
                }
                break
                
            case .failure(_):
                    APIManager.sharedInstance.customPOP(isError: true, message: response.result.error!.localizedDescription)
                break
                
            }
        }
    }
    
    
    
    
    
    //Cart count
    func cartCount() {
        if let customerId = APIManager.sharedInstance.getCustomer()?.customer_id {
            getCartItems(customerId: customerId)
        }else {
            getCartItems(customerId: "")
        }
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
                    self.cartButton.badgeString = "\(totalItemsInCart)"
                    let subCatCart = QSubCategoriesVC()
                    subCatCart.cartButton.badgeString = "\(cart?.count ?? 0)"
                }
                break
            case .failure(_):
                break
                
            }
        }
        
    }
    
    
    
    @objc func getCart(_ notification: NSNotification)  {
        cartCount()
    }
    
    
    
    func getProductByPagination(startIndex: Int)  {
        guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id  else { return }
        guard let catId = self.id else { return }
        
        if APIManager.sharedInstance.getLocation().isLocation {
            if self.isSearch == .Id {
               getSubCatProducts(sellerId: sellerId, catId: catId,  areaId: "", searchBy: .Id, type: .Location, startIndex: startIndex)
            }
        }else {
            if self.isSearch == .Id {
                guard let areaId = APIManager.sharedInstance.getCityAndArea()?.areaId else {  return }
                getSubCatProducts(sellerId: sellerId, catId: catId,  areaId: areaId, searchBy: .Id, type: .Store, startIndex: startIndex)
            }
        }
  
        
    }
    
    
    
    
    
    
 ///    GET WISH LIST
    func getSubCatProducts(sellerId: String, catId: String, areaId: String, searchBy: SearchBy,type: UrlType ,startIndex: Int) {
        var url = ""
        let languageId = APIManager.sharedInstance.getLanguage()!.id
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""
        self.id = catId
        if type == .Store {
            switch searchBy {
            case .Id:
                url = GET_PRODUCTS_BY_SUBCATEGORY_ID + "getProductByAreaID2?seller_id=\(sellerId)&cat_id=\(catId)&areaID=\(areaId)&start=\(startIndex)&end=300&city_id=\(city_Id)&language_id=\(languageId)"
            case .Name:
                url = GET_PRODUCTS_BY_SUBCATEGORY_ID + "search2?search=\(catId)&seller_id=\(sellerId)&start=\(startIndex)&end=300&city_id=\(city_Id)&language_id=\(languageId)"
            }
        } else {
            
            switch searchBy {
            case .Id:
                   url = GET_PRODUCTS_BY_SUBCATEGORY_ID + "getProductBYcategoryAndLoc2?seller_id=\(sellerId)&cat_id=\(catId)&start=\(startIndex)&end=300&latitude=\(APIManager.sharedInstance.getLocation().latitude)&longitude=\(APIManager.sharedInstance.getLocation().lngitude)&city_id=\(city_Id)&language_id=\(languageId)"
            case .Name:
                url = GET_PRODUCTS_BY_SUBCATEGORY_ID + "search2?search=\(catId)&seller_id=\(sellerId)&start=\(startIndex)&end=300&city_id=\(city_Id)&language_id=\(languageId)"
            }
        }
        
    
        
        let idofAppointmet = ["":""] as [String : AnyObject]
        WebServiceManager.get(params : idofAppointmet , serviceName: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "sub categories", modelType: FeaturedProducts.self, success: { (response) in
                    let data = (response as! FeaturedProducts)
                    if data.message?.lowercased() == "success" {
                        let count = self.subCatProducts?.count
//                        if searchBy == SearchBy.Name {
                        
                            if self.subCatProducts?.count != 0 && self.subCatProducts != nil {
                                if let pro = data.subProducts {
                                    self.subCatProducts = self.subCatProducts! + pro
//                                    self.startIndex += 9
                                }
                            } else {
                                self.subCatProducts = data.subProducts
                                
                            }
                            if let proCount =  self.subCatProducts?.count {
                                if proCount > count ?? 0 {
                                    self.startIndex += 9
                                }
                            }
        
                        self.productCollectionView.delegate = self
                        self.productCollectionView.dataSource = self
                        self.productCollectionView.reloadData()
                        if self.subCatProducts?.count ?? 0 >= 9 {
                            self.isLoadMore = false
                        }else {
                            self.isLoadMore = true
                        }
                        
                        if self.subCatProducts?.count != 0 && self.subCatProducts != nil {
                         
                            self.noDataView.isHidden = true
                        }else {
                            self.noDataView.isHidden = false
                            self.isLoadMore = true
                        }
        
                    }else {
                        
//                        APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
                    }

                }) { (error) in
                    APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
                }
            
            }
    
    
    
}


