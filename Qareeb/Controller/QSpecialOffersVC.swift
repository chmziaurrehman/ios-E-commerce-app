//
//  QWishListVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 22/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import Kingfisher
import SVProgressHUD
import CoreLocation

class QSpecialOffersVC: UIViewController {
    
    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblSpecialOffers: UILabel!
    @IBOutlet weak var lblNodataAvailable: UILabel!
    @IBOutlet weak var lblSubtitleNoData: UILabel!

    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var products : FeaturedProducts?
    
    let settingVC : QProductVC = QProductVC(nibName: "QProductVC", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        localizeStrings()
        collectionView.register(UINib(nibName: "QProductCell", bundle: nil), forCellWithReuseIdentifier: "QProductCell")
    
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: (screenWidth/3) - 13, height: self.view.frame.height / 4.3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        // Do any additional setup after loading the view.
        
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id  else {  return }
        getFeaturedProducts(sellerId: sellerId)
    }
    
    //Localization configrations
    func localizeStrings() {
//        LocalizationSystem.shared.setLanguage(languageCode: language)
        lblSpecialOffers.text = LocalizationSystem.shared.localizedStringForKey(key: "special_offers", comment: "")
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



extension QSpecialOffersVC:  UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.products?.products?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QProductCell", for: indexPath) as! QProductCell
        let product = self.products?.products?[indexPath.row]
        cell.imgSale.isHidden = true
        cell.lblSalePercent.isHidden = true
        cell.labelConst.constant = cell.frame.width / 2.3
        cell.lblPrice.textAlignment = .left
        APIManager.sharedInstance.strikeOnLabel(value: product?.price, label: cell.lblDiscount)
        cell.layoutIfNeeded()
//        cell.lblDiscount.text =  "0.0"
        cell.lblPrice.text = product?.special
        cell.lblProductName.text = product?.name
        
        
        // Special products with special price
        product?.price = product?.price?.replacingOccurrences(of: " SR", with: "", options: NSString.CompareOptions.literal, range:nil)
        
        if product?.special != "0" && product?.special != nil {
            cell.specialConst.constant = cell.frame.width / 2.5
            cell.layoutIfNeeded()
            APIManager.sharedInstance.strikeOnLabel(value: product?.price, label: cell.lblDiscount)
            cell.lblPrice.text           = product?.special
            if let special = product?.special ,let price = product?.price {
                cell.discountSetUp(isDiscount: true, "\(APIManager.sharedInstance.countDiscount(special: special, price: price))")
            }
        }else {
            cell.discountSetUp(isDiscount: false, "")
            cell.specialConst.constant = 0
            cell.lblPrice.text  =   product?.price
            cell.lblPrice.textAlignment = .center
        }
        
        

        if let url =  product?.image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            let resource = ImageResource(downloadURL:   URL(string: url)! , cacheKey: url)
            cell.imgProduct.kf.setImage(with: resource, placeholder: UIImage(named: IMAGE_PLACEHOLDER), options: [.transition(ImageTransition.fade(1))], progressBlock: { (recievedSize, totalSize) in
                //                print((1 / totalSize) * 100)
            }, completionHandler: nil)
        }
        if (Int(product?.quantity ?? "0")!) >= (Int(cell.lblCount.text!)!) {
            cell.isOutOfStock(false)
        } else {
            cell.isOutOfStock(true)
        }
    
//        let product = self.products?.products?[indexPath.row]
        cell.minus = {() -> Void in
            self.addToCartMinus(productId: product?.product_id ?? "0", label: cell.lblCount ,index: indexPath.row)
        }
        
        cell.plus = {() -> Void in
            if (Int(product?.quantity ?? "0")!) >= (Int(cell.lblCount.text!)!) {
                cell.isOutOfStock(false)
                if product?.option_available == 1  {
                    self.movetoProductDetailView(product: product)
                }else {
                    self.addTeCartItemPlus(productId: product?.product_id ?? "0", label: cell.lblCount ,index: indexPath.row)
                }
            } else {
                cell.isOutOfStock(true)
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        movetoProductDetailView(product: self.products?.products?[indexPath.row])
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
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
        //        productVC.didMove(toParent: self)
        settingVC.view.frame = window.bounds
        settingVC.closeProductView = {()-> Void in
            self.settingVC.view.removeFromSuperview()
        }
    }
    
    func getLocation() {
        func getUserLocation() {
            _ =  Location.getLocation(withAccuracy:.block, frequency: .oneShot, onSuccess: { [weak self] location in
                //            print("loc \(location.coordinate.longitude)\(location.coordinate.latitude)")
                DEVICE_LAT = location.coordinate.latitude
                DEVICE_LONG = location.coordinate.longitude
                guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id  else {  return }
                self?.getFeaturedProducts(sellerId: sellerId)
                }, onError: { (last, error) in
                    print("Something bad has occurred \(error)")
            })
            
        }
    }
    
//
//
////    // Featured Service
    func getFeaturedProducts(sellerId : String) {
        let idofAppointmet = [ "": "" ] as [String : AnyObject]
        var url = ""
        let cityId = APIManager.sharedInstance.getStore()?.city_id ?? "0"
        if APIManager.sharedInstance.getLocation().isLocation {
            let lang = APIManager.sharedInstance.getLanguage()?.id
            let lat = APIManager.sharedInstance.getLocation().latitude
            let lan = APIManager.sharedInstance.getLocation().lngitude
            let rad = APIManager.sharedInstance.getLocation().radius
            if lat == 0.0 {
                getLocation()
                return
            }
            url = GET_SPECIAL_OFFERS_BY_LOCATION + "seller=\(sellerId)&device_id=&language_id=\(lang!)&is_area=0&lat=\(lat)&lng=\(lan)&radius=\(rad)&city_id=\(cityId)"
        }else {
            guard let areaId = APIManager.sharedInstance.getCityAndArea()?.areaId  else {  return }
            url = "https://qareeb.com/index.php?route=product/productapi/getSpecialProductsBySeller&seller=\(sellerId)&language_id=\(APIManager.sharedInstance.getLanguage()!.id)&area=\(areaId)&is_area=1&ios=1&city_id=\(cityId)"
        }
        
        WebServiceManager.get(params : idofAppointmet, serviceName: url , header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Special Procuts", modelType: FeaturedProducts.self, success: { (response) in
            
            let data = (response as! FeaturedProducts)
            
            if data.products?.count != 0 {
                
                self.products = data
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
                self.noDataView.isHidden = true

            }else {
//                APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
            }

        }) { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
    }
    
    

}
