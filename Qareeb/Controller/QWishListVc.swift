//
//  QWishListVc.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 23/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import SVProgressHUD
import ObjectMapper
import Kingfisher
import Alamofire

class QWishListVc: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var lblWishlist: UILabel!
    @IBOutlet weak var lblNodataAvailable: UILabel!
    @IBOutlet weak var lblSubtitleNoData: UILabel!
    
    
    var wishList: [Product]?
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()

    override func viewDidLoad() {
        super.viewDidLoad()

        localizeStrings()
        collectionView.register(UINib(nibName: "QWishlistCell", bundle: nil), forCellWithReuseIdentifier: "QWishlistCell")
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: self.view.frame.width / 3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {//
            APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
            return
        }
        
        // Getting wish list
        getWishListByCustomerId(customerId: customerId)
    }
    //Wishlist
    //Localization configrations
    func localizeStrings() {
//        LocalizationSystem.shared.setLanguage(languageCode: language)
        lblWishlist.text = LocalizationSystem.shared.localizedStringForKey(key: "Wishlist", comment: "")
        lblNodataAvailable.text = LocalizationSystem.shared.localizedStringForKey(key: "Data_not_found", comment: "")
        lblSubtitleNoData.text = LocalizationSystem.shared.localizedStringForKey(key: "there_is_no_data_to_show_you", comment: "")
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension QWishListVc:  UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.wishList?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QWishlistCell", for: indexPath) as! QWishlistCell

        cell.lblPrice.text = self.wishList?[indexPath.item].price
        cell.lblTitle.text = self.wishList?[indexPath.item].name
        
        cell.imgProduct.loadImage(from: self.wishList?[indexPath.item].image, isBaseUrl: false)
        if let special = self.wishList?[indexPath.item].special {
            APIManager.sharedInstance.strikeOnLabel(value: special, label: cell.lblSpecial)
        }else {
            cell.lblSpecial.text = ""
            
        }
        
        cell.addToCart = {() -> Void in
            self.addToCartProduct(index: indexPath.item)
        }
        cell.delete = {() -> Void in
            self.deleteFromWishList(index: indexPath.item)
        }
        cell.share = {() -> Void in
            APIManager.sharedInstance.shareProduct(imageUrl:  self.wishList?[indexPath.item].image, self)
        }
//        print(self.wishList?[indexPath.item].seller_id)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//      print(self.wishList?[indexPath.item].seller_id)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        return CGFloat(5)
    }
    
    
    func deleteFromWishList(index: Int)  {
        if let product =  self.wishList?[index] {
            guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
                APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
                return
            }
            deleteProductFromWishList(productId: product.product_id!, customerId: customerId, sellerId: product.seller_id!, index: index)
        }
    }
    
 
    
    func addToCartProduct(index: Int)  {
        if let product = self.wishList?[index] {
            guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
                APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
                return
            }
            guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else {return}
            if product.seller_id == nil {
                product.seller_id = sellerId
            }
            if product.seller_id == sellerId {
              addToCart(productId: product.product_id!, customerId: customerId, sellerId: sellerId, languageId: APIManager.sharedInstance.languageId)
            } else {
                APIManager.sharedInstance.customPOP(isError: true, message: "Product is from an other Store, if you want to add this product change your store")
            }
            
        } else {
            APIManager.sharedInstance.customPOP(isError: true, message: "Something went wrong try again")
        }
     
    }
    
    
    
    
    
    
    // DELETE PRODUCT FROM WISHLIST
    
    func addToCart(productId: String, customerId : String, sellerId: String, languageId: String) {
        let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""

        let params = [  "product_id"        : productId,
                        "product_quantity"  : "1",
                        "customer_id"       : customerId,
                        "seller_id"         : sellerId,
                        "language_id"       : languageId,
                        "city_id"           : city_Id
            ] as [String : AnyObject]
        
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: ADD_TO_CART, header: header, serviceType: "ADD TO CART PRODUCT" , modelType: FeaturedProducts.self, success: { (response) in
            let user = (response as! FeaturedProducts)
            if user.msg == "success" {
               APIManager.sharedInstance.customPOP(isError: false, message: "Product successfully added to your shopping cart")
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.msg ?? ERROR_MESSAGE)
            }
            
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
    
    
    // DELETE PRODUCT FROM WISHLIST
    
    func deleteProductFromWishList(productId: String, customerId : String, sellerId: String, index : Int) {
        let params = [  "product_id" : productId,
                        "customer_id" : customerId,
                        "seller_id" :sellerId,
                        "ios"   :   "1"
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: DELETE_FROM_WISHLIST, header: header, serviceType: "User LogIn" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            if user.msg?.lowercased() == "success" {
                self.wishList?.remove(at: index)
                self.collectionView.reloadData()
                APIManager.sharedInstance.customPOP(isError: false, message: user.result ?? "Product Removed from Wishlist")
            }else {
                APIManager.sharedInstance.customPOP(isError: false, message: "Try again")
            }
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
    
       func getWishListByCustomerId(customerId: String) {
            let idofAppointmet = [ "": "" ] as [String : AnyObject]
            let languageId = APIManager.sharedInstance.getLanguage()!.id
            let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""
            let url = WISH_LIST + customerId + "&ios=1&city_id=\(city_Id)&language=\(languageId)"
            WebServiceManager.get(params : idofAppointmet, serviceName: url , header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Special Procuts", modelType: FeaturedProducts.self, success: { (response) in
                let data = (response as! FeaturedProducts)
                if data.msg?.lowercased() == "success" {
    
                    self.wishList = data.result
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    if self.wishList?.count != 0 {
                        self.noDataView.isHidden = true
                    }else {
                        self.noDataView.isHidden = false
                    }
                    
                }else {
                    APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
                }
    
            }) { (error) in
                APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            }
        }
    
}
