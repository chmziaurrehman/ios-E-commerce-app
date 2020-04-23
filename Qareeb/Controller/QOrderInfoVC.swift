//
//  QOrderInfoVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 28/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import Kingfisher

class QOrderInfoVC: UIViewController {

    @IBOutlet weak var orderInfoView: UIViewX!
    @IBOutlet weak var btnOrderInfo: UIButton!
    @IBOutlet weak var btnCart: UIButton!
    @IBOutlet weak var cartView: UIViewX!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewInfo: UIView!
    
    @IBOutlet weak var lblId: UILabel!
    @IBOutlet weak var lblDateAndtime: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPaymentMethod: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    
    @IBOutlet weak var labelOrderDetails: UILabel!
    @IBOutlet weak var labelOrderId: UILabel!
    @IBOutlet weak var labelOrderDateTime: UILabel!
    @IBOutlet weak var labelDeliveryAddress: UILabel!
    @IBOutlet weak var labelPaymentDetail: UILabel!
    @IBOutlet weak var labelPaymentMethod: UILabel!
    @IBOutlet weak var LabelStatus: UILabel!
    
    
    
    var orderHistory: Order?
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    let alertView : QAlertViewPopUp = UIView.fromNib()


    var orders: Order?
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "QOrderInfoCell", bundle: nil), forCellWithReuseIdentifier: "QOrderInfoCell")
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth , height: self.view.frame.width / 3)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: "")); return }
        guard let id = orderHistory?.order_id else { return }
        getOrdersInfo(customerId: customerId, id: id)
        // Do any additional setup after loading the view.
        localizeStrings()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    
    
    //Localization configrations
    func localizeStrings() {
        title = LocalizationSystem.shared.localizedStringForKey(key: "Orders", comment: "")
        labelOrderDetails.text = LocalizationSystem.shared.localizedStringForKey(key: "Orders_Details", comment: "")
        labelOrderId.text = LocalizationSystem.shared.localizedStringForKey(key: "Order_IDs", comment: "")
        labelOrderDateTime.text = LocalizationSystem.shared.localizedStringForKey(key: "order_date_time", comment: "")
        labelDeliveryAddress.text = LocalizationSystem.shared.localizedStringForKey(key: "Delivery_Address", comment: "")
        labelPaymentDetail.text = LocalizationSystem.shared.localizedStringForKey(key: "Payment_Details", comment: "")
        labelPaymentMethod.text = LocalizationSystem.shared.localizedStringForKey(key: "Payment_Method", comment: "")
        LabelStatus.text = LocalizationSystem.shared.localizedStringForKey(key: "Status", comment: "")
        btnOrderInfo.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Order_Info", comment: ""), for: .normal)
        btnCart.setTitle("\(LocalizationSystem.shared.localizedStringForKey(key: "Product_in_Cart_0", comment: "")) (0))", for: .normal)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func btnOderInfo(_ sender: Any) {
        self.orderInfoView.backgroundColor = UIColor(named: "blueberry")
        self.cartView.backgroundColor = .white
        viewInfo.isHidden = false
    }
    @IBAction func btnProductsInCart(_ sender: Any) {
        self.orderInfoView.backgroundColor = .white
        self.cartView.backgroundColor = UIColor(named: "blueberry")
        viewInfo.isHidden = true
    }
    
    
    
    

}




extension QOrderInfoVC:  UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orders?.OrderProducts?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QOrderInfoCell", for: indexPath) as! QOrderInfoCell
            let orderInfo = self.orders?.OrderProducts?[indexPath.item]
            cell.lblName.text = orderInfo?.name
            cell.lblPrice.text = orderInfo?.price
            if let quantity = orderInfo?.quantity {
                cell.lblQuantity.text = "Quantity: " + quantity
            }
            if let upc = orderInfo?.upc {
                cell.lblUPC.text = "UPC: " + upc
            }
        
        
        
            if let url =  orderInfo?.image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                let resource = ImageResource(downloadURL:  URL(string: IMAGE_BASE_URL + url)!, cacheKey: url)
                cell.imgOrder.kf.setImage(with: resource, placeholder: UIImage(named: IMAGE_PLACEHOLDER), options: [.transition(ImageTransition.fade(1))], progressBlock: { (recievedSize, totalSize) in
                    //                            print((1 / totalSize) * 100)
                }, completionHandler: nil)
            }
            cell.addtoCart = {() -> Void in
                self.addToCartItem(indexpath: indexPath)
            }
        
            cell.share = {() -> Void in
                APIManager.sharedInstance.shareProduct(imageUrl:  orderInfo?.image, self)
            }

//            cell.lblPrice.text = orderInfo?.total
//            cell.lblQuantity.text = "Quantity: \(orderInfo?.products ?? 0)"
//            cell.lblUPC.text = orderInfo?.status
//            APIManager.sharedInstance.downloadImage(from: URL(string: orderInfo) ?? URL(string: "https://www.qareeb.com/image/cache/catalog/UPC/6281036108401-300x300.JPG")!, to: cell.imgOrder)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//      validateStore(productId: orderInfo!.id!, sellerId: orderInfo!.seller_id!, areaId: APIManager.sharedInstance.getCityAndArea()!.areaId!)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        return CGFloat(0)
    }
 
    func addToCartItem(indexpath: IndexPath)  {
        let orderInfo = self.orders?.OrderProducts?[indexpath.item]
        if orderInfo?.seller_id == APIManager.sharedInstance.getStore()?.seller_id {
            APIManager.sharedInstance.addToCart(productId: orderInfo!.id!, productQuantiy: orderInfo!.quantity!)
        } else {
            window.addSubview(self.alertView)
            self.alertView.frame = window.bounds
            self.alertView.lblWarning.text = "\(orderInfo!.name!.uppercased()) is from \(orderInfo!.seller_name!.uppercased()) store. If you want to add to cart please change your store."
        }
        //
    }
    
    
    
    
    
    
    
    
    
//    func getOrdersInfo(customerId: String, id: String) {
//        WebServiceManager.progressHudSetting()
//        SVProgressHUD.show()
//        let url = ORDER_INFO + "order_id=\(id)&customer_id=\(customerId)&language_id=\(APIManager.sharedInstance.languageId)"
//        Alamofire.request(  url , method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            SVProgressHUD.dismiss()
//            switch(response.result) {
//            case .success(_):
//                if let data = response.result.value{
//                    let orders = Mapper<Order>().mapArray(JSONObject: data)
//
//                }
//                break
//
//            case .failure(_):
//                APIManager.sharedInstance.customPOP(isError: true, message: ERROR_MESSAGE)
//                break
//
//            }
//        }
//
//    }
    
    
     func getOrdersInfo(customerId: String, id: String) {
        let idofAppointmet = [ "": "" ] as [String : AnyObject]
        let languageId = APIManager.sharedInstance.getLanguage()!.id
        let url = ORDER_INFO + "order_id=\(id)&customer_id=\(customerId)&language_id=" + languageId
        WebServiceManager.get(params : idofAppointmet, serviceName: url, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Special Procuts", modelType: Order.self, success: { (response) in
            let data = (response as! Order)
            if data.order_id != "" {
                self.orders = data
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
                self.btnCart.setTitle("\(LocalizationSystem.shared.localizedStringForKey(key: "Product_in_Cart_0", comment: "")) (\(data.OrderProducts?.count ?? 0))", for: .normal)
                
                self.lblId.text = data.order_id
                self.lblDateAndtime.text = "\(data.delivery_date_time?.date ?? "0/0/0000") \(data.delivery_date_time?.time ?? "00:00")"
//                self.lblName.text = self.orderHistory?.name
                self.lblStatus.text = self.orderHistory?.status
                self.lblAddress.text = data.shipping_address
                self.lblPaymentMethod.text = data.payment_method

            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: ERROR_MESSAGE)
            }

            
        }) { (error) in
//            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
    }
    
    
    // MARK:- Validate Store
    
    func validateStore(productId: String, sellerId: String, areaId: String) {
        
        let idofAppointmet = [ "": "" ] as [String : AnyObject]
        
        let url = VALIDATE_STORE + "product_id=\(productId)&seller_req=\(sellerId)&is_area=1&area_id=\(areaId)"
        
        WebServiceManager.get(params : idofAppointmet, serviceName: url, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Validat Store", modelType: StoreValidate.self, success: { (response) in
            let data = (response as! StoreValidate)
            print(data)
            //            if data.msg?.lowercased() == "success" {
            //
            //            }else {
            //                APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
            //            }
            
        }) { (error) in
//            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
    }
}
