//
//  QHomeSearchVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 15/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import ObjectMapper
import SVProgressHUD
import MIBadgeButton_Swift

class QHomeSearchVC: UIViewController , UIScrollViewDelegate{
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    let layout: UICollectionViewFlowLayout  = UICollectionViewFlowLayout()
    let layout2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var subCategory :    MainCatetogries?
    var mainCategories : [MainCatetogries]?
    var subCatProducts : [[Product]]?
    //    var storeDate: Results?
    
    var startIndex = 0
    
    let settingVC : QProductVC = QProductVC(nibName: "QProductVC", bundle: nil)
    
    var page:Int            = 0
    var isLoadMore: Bool    = false
    var isSearch            = SearchBy.Id
    let cartButton          = MIBadgeButton(type: .custom)
    var searchProducts : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getCart), name: NSNotification.Name(rawValue: "getCart"), object: nil)
        productCollectionView.register(UINib(nibName: "QProductCell", bundle: nil), forCellWithReuseIdentifier: "QProductCell")
        
        productCollectionView.register(UINib(nibName: "QStoreHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "QStoreHeaderCell")
        // Do any additional setup after loading the view.
        
        // RIGHT NAVIGATION BAR BUTTON TO ACCESS CART VIEW
        
        
        cartButton.setImage(UIImage(named: "addToCartIcon"), for: .normal)
        cartButton.addTarget(self, action: #selector(openCart), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: cartButton)
        
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
//        self.navigationItem.backBarButtonItem?.title = " "
        
        //Setting up collection view layouts
        layout2.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout2.minimumInteritemSpacing = 0
        layout2.minimumLineSpacing = 0
        layout2.scrollDirection = .vertical
        productCollectionView!.collectionViewLayout = layout2
        //Calling service get products by Name
        if let searchName = searchProducts {
            self.txtSearch.text = searchName
            getProductsByName(index: 0)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: .getCart, object: nil)        
    }
    override func viewDidLayoutSubviews() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // Open cart button action fuction
    @objc func openCart() -> Void {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QCartVc") as? QCartVc
        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    

    

    @IBAction func btnChange(_ sender: Any) {
        self.view.endEditing(true)
        self.isSearch = SearchBy.Name
        self.subCatProducts?.removeAll()
        self.productCollectionView.reloadData()
        getProductsByName(index: 0)
        
    }
    
    
    func getProductsByName(index : Int) {
        guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else {  return }
//        guard let areaId = APIManager.sharedInstance.getCityAndArea()?.areaId else {  return }
        guard let language = APIManager.sharedInstance.getLanguage()?.id else { return }
        
        if self.txtSearch.text != "" {
            getSubCatProducts(sellerId: sellerId, catId: self.txtSearch.text! , langId: language, areaId: "", startIndex: index)
        }
    }
    
    
}




// MARK:- COLLECTION VIEW DELEGATES
extension QHomeSearchVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.subCatProducts?.count ?? 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "QProductCell", for: indexPath) as! QProductCell
            if  let product = self.subCatProducts?[indexPath.item].first {
                
                cell.lblProductName.text = product.name
                cell.lblPrice.text = "\(product.priceNew ?? 0.0)"
                
                
                
                
                
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
                }else {
                    cell.discountSetUp(isDiscount: false, "")
                    cell.specialConst.constant = 0
                    cell.lblPrice.text           = "\(product.priceNew ?? 0.0)"
                    cell.lblPrice.textAlignment = .center
                }
                
                
                
                
                
                
                
                
                if let url =  product.image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                    let resource = ImageResource(downloadURL:  URL(string: IMAGE_BASE_URL + url)!, cacheKey: url)
                    cell.imgProduct.kf.setImage(with: resource, placeholder: UIImage(named: IMAGE_PLACEHOLDER), options: [.transition(ImageTransition.fade(1))], progressBlock: { (recievedSize, totalSize) in
                        //                            print((1 / totalSize) * 100)
                    }, completionHandler: nil)
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
                    if product.option_available == 1  {
                        self.movetoProductDetailView(product: product)
                    } else {
                        self.addTeCartItemPlus(productId: "\(product.productId ?? 00)", label: cell.lblCount ,index: indexPath.row)
                    }
                }
            }
            
            
            
            return cell
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = self.subCatProducts?[indexPath.item].first {
         movetoProductDetailView(product: product)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("Prefetch: \(indexPaths)")
//        for indexPath in indexPaths {
//
//        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if indexPath.item == self.subCatProducts?.count { // or if indexPath.row == myDat.count
            // CollectionView is scrolled to the bottom
            print("loading......")
            // Do something
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.view.frame.width / 3) - 13, height: self.view.frame.height / 4)
    }
    
    
    
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "QStoreHeaderCell", for: indexPath) as! QStoreHeaderCell
 
                if !self.isLoadMore {
                    getProductsByName(index: self.startIndex)
                    self.isLoadMore = true
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
    
    
    
    //Move to product detail View
    
    
    
    
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
        Alamofire.request( GET_CART + "language=" + lang + "&customer_id=\(customerId)&device_id=\(token)", method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let cart = Mapper<CartModel>().mapArray(JSONObject: data)
                    self.cartButton.badgeString = "\(cart?.count ?? 0)"
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

    ///    GET WISH LIST
    func getSubCatProducts(sellerId: String, catId: String, langId : String, areaId: String ,startIndex: Int) {
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""

        let url = GET_PRODUCTS_BY_SUBCATEGORY_ID + "search2?search=\(catId)&seller_id=\(sellerId)&start=\(startIndex)&end=300&city_id=\(city_Id)&language_id=\(langId)"

        let idofAppointmet = ["":""] as [String : AnyObject]
        WebServiceManager.get(params : idofAppointmet , serviceName: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "sub categories", modelType: FeaturedProducts.self, success: { (response) in
            let data = (response as! FeaturedProducts)
            if data.message?.lowercased() == "success" {
                
                let count = self.subCatProducts?.count
                
                    if self.subCatProducts?.count != 0 && self.subCatProducts != nil {
                        if let pro = data.subProducts {
                            self.subCatProducts = self.subCatProducts! + pro
                            
                        }
                    }else {
                        self.subCatProducts = data.subProducts
                    }
          
                if let proCount =  self.subCatProducts?.count {
                    
                    if proCount > count ?? 0 {
                        self.productCollectionView.delegate = self
                        self.productCollectionView.dataSource = self
                        self.productCollectionView.prefetchDataSource = self
                        self.productCollectionView.reloadData()
                        self.startIndex += 9
                    }
                }
             
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
                
                APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
            }
            
        }) { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
        
    }
    
    
    
}


