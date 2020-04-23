//
//  QProductVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 22/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD
import Kingfisher
import DropDown
import ImageSlideshow


class QProductVC: UIViewController{
    
    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var imgLike: UIImageView!
    @IBOutlet weak var lblSale: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblWeight: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblQuantity: UILabel!
    @IBOutlet weak var lblDescription: UITextView!
    @IBOutlet weak var imgSale: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var specialLabelConst: NSLayoutConstraint!
    @IBOutlet weak var lblSpecial: UILabel!
    @IBOutlet weak var weightView: UIViewX!
    
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var relatedItemsLabel: UILabel!
    @IBOutlet weak var btnAddToCart: UIButton!
    @IBOutlet weak var btnViewMore: UIButton!
    @IBOutlet weak var btnOptions: UIButton!
    
    @IBOutlet weak var imageViewSlider: UIView!
    let optionView : QProductOptionView = UIView.fromNib()
    let descriptionView : QDescriptionView  = UIView.fromNib()

    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var closeProductView:(()-> Void)!
    
    var relatedProducts : [Product]?
    weak var currentProduct : Product?
    var singleProduct : Product?
    var productWithDetail : Product?
    var count = 1
    var varients : [Product_option_value]?
    let dropDown = DropDown()
    var product_option_value_id = ""
    var product_option_id = ""
    var optionsParams = [String : AnyObject]()
    var optionsCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        localizeStrings()
        collectionView.register(UINib(nibName: "QProductCell", bundle: nil), forCellWithReuseIdentifier: "QProductCell")
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        
        layout.sectionInset = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 15)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
//        strikeOnLabel()
        
    
        // Do any additional setup after loading the view.
        
//        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//
//            self.lblWeight.text =  self.varients?[index].name
//            self.product_option_value_id = self.varients?[index].product_option_value_id
//        }
        
        optionView.selectedOptions = {()-> Void in
            var singleOption = [String : AnyObject]()
            for i  in 0..<(self.productWithDetail?.options?.count ?? 0) {
                var optionValueId = String()
                for j  in 0..<(self.productWithDetail?.options?[i].product_option_value?.count ?? 0) {
                    if self.productWithDetail?.options?[i].product_option_value?[j].isSelected == true {
                        let optValueId = self.productWithDetail?.options?[i].product_option_value?[j].option_value_id ?? "0"
                        let optId = self.productWithDetail?.options?[i].product_option_id ?? "0"
                        if self.optionsCount == 0 {
                            optionValueId = optionValueId + optValueId
                            singleOption["option[\(optId)]"] = "\(optionValueId)" as AnyObject
                        } else {
                            optionValueId = optionValueId + ",\(optValueId)"
                            singleOption["option[\(optId)]"] = optionValueId as AnyObject
                        }
                        
                        self.optionsCount += 1
                    }
                }
            }
            self.optionsParams = singleOption
            switch self.optionsCount {
            case 0:
                self.lblWeight.text = "Select"
            case 1:
                self.lblWeight.text = "Single option selected"
            default:
                self.lblWeight.text = "Multiple options selected"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        clearViewData()
        self.singleProduct = self.currentProduct
        if let product = self.singleProduct {
//            setProductData(product: product)
            getProductDetails(productId: product.product_id ?? "")
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
        layout.itemSize = CGSize(width: (screenWidth/4.4) , height: self.collectionView.frame.height - 3)
        collectionView!.collectionViewLayout = layout

    }
    
    deinit {
        print("deinit product view")
    }
    
    func clearViewData() {
         self.imgLike.image = #imageLiteral(resourceName: "likeIcon-1")
        self.relatedProducts?.removeAll()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        self.lblName.text = ""
        self.lblQuantity.text = "1"
        self.lblPrice.text = "0.0"
        self.lblDescription.text = ""
       
        
    }
    
    
    
    //Localization configrations
    func localizeStrings() {
        quantityLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Quantity", comment: "")
        weightLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "options", comment: "")
        relatedItemsLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Related_Items", comment: "")
        desLabel.text = LocalizationSystem.shared.localizedStringForKey(key: "Description", comment: "")
        btnViewMore.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "view_more", comment: ""), for: .normal)
        btnAddToCart.setTitle(" "+LocalizationSystem.shared.localizedStringForKey(key: "ADD_TO_CART", comment: "")+"  ", for: .normal)
    }
    
    func selectProductOptions(sender: UIViewX)  {
//        dropDown.anchorView = sender
//        dropDown.cellHeight = 30
//        dropDown.cornerRadius = 2
//        dropDown.textFont = UIFont(name: "Montserrat-Regular", size: 10)
//        self.dropDown.bottomOffset = CGPoint(x: 0, y:((self.dropDown.anchorView?.plainView.bounds.height)!) + CGFloat(3.0))
//        if let weight = self.varients?.map({$0.name}) {
//            self.dropDown.dataSource = weight as! [String]
//            self.dropDown.show()
//        }
//        self.dropDown.show()
        for i  in 0..<(self.productWithDetail?.options?.count ?? 0) {
            for j  in 0..<(self.productWithDetail?.options?[i].product_option_value?.count ?? 0) {
                if self.productWithDetail?.options?[i].product_option_value?[j].isSelected == true {
                    self.productWithDetail?.options?[i].product_option_value?[j].isSelected = false
                }
            }
        }
        
        self.optionsCount = 0
        optionView.frame = window.bounds
        optionView.productWithDetail = self.productWithDetail
        window.addSubview(optionView)
        optionView.animatedConst.constant = window.frame.height
        optionView.loadAnimatedView()
    }
    
    // MARK: - SET PRODUCT DATA
    
    func setProductData(product:Product) {
        
        self.lblWeight.text = "Select"
        if product.option_available == 1 {
            self.btnOptions.isEnabled = true
        } else {
            self.btnOptions.isEnabled = false
        }
        
        APIManager.sharedInstance.downloadImage(from: product.thumb, to: imgProduct)
        lblName.text = product.name
//
        lblDescription.text = product.desc
        if let url =  product.images?.first?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            let resource = ImageResource(downloadURL:   URL(string: url)! , cacheKey: url)
            imgProduct.kf.setImage(with: resource, placeholder: UIImage(named: IMAGE_PLACEHOLDER), options: [.transition(ImageTransition.fade(1))], progressBlock: { (recievedSize, totalSize) in
            }, completionHandler: nil)
        }
        
        if product.special != nil && product.special != "0" {
            self.view.layoutIfNeeded()
            self.specialLabelConst.constant = self.view.frame.width / 2.5
            APIManager.sharedInstance.strikeOnLabel(value: product.price, label: lblSpecial)
            lblPrice.text   =   product.special
            lblPrice.textAlignment = .left
            lblSpecial.textAlignment = .right
            if let special = product.special ,let price = product.price {
                discountSetUp(isDiscount: true, "\(APIManager.sharedInstance.countDiscount(special: special, price: price))")
            }
        }else {
            discountSetUp(isDiscount: false, "")
            self.specialLabelConst.constant = 0
            lblPrice.text = product.price
            lblPrice.textAlignment = .center
        }
        if product.in_wishlist == 0 {
            imgLike.image =  #imageLiteral(resourceName: "likeIcon-1")
        }else {
            self.imgLike.image = #imageLiteral(resourceName: "likedProduct")
        }
        
        let sliderView: ImageSlideshow  =  ImageSlideshow(frame: CGRect(x: 0, y: 0, width: self.imageViewSlider.frame.width, height: self.imageViewSlider.frame.height))
        imageViewSlider.addSubview(sliderView)

        if let productImages = product.images {
            sliderView.backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.9843137255, blue: 0.9921568627, alpha: 1)
            sliderView.setProductImages(images: productImages)
            }
        
        
        if APIManager.sharedInstance.getLocation().isLocation {
            getSellerRelatedProducts(productId: product.product_id!, sellerId: APIManager.sharedInstance.getStore()!.seller_id!, areaId: "")
        }else {
          getSellerRelatedProducts(productId: product.product_id!, sellerId: APIManager.sharedInstance.getStore()!.seller_id!, areaId: APIManager.sharedInstance.getCityAndArea()!.areaId!)
        }
    }
    
    
    // Discount price setting
    func discountSetUp( isDiscount : Bool , _ amount : String) {
        if isDiscount {
            imgSale.isHidden    = !isDiscount
            lblSale.isHidden    = !isDiscount
            lblSale.text        = amount + "%"
        }else {
            imgSale.isHidden    = !isDiscount
            lblSale.isHidden    = !isDiscount
        }
    }

    func removeFromWishList(productId: String)  {
            guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
                APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
                return
            }
            
        deleteProductFromWishList(productId: productId, customerId: customerId)
    }


    @IBAction func btnClose(_ sender: Any) {
        self.closeProductView()
    }
    @IBAction func btnLike(_ sender: UIButton) {
        
        guard let sellerId = APIManager.sharedInstance.getStore()?.seller_id else { return }
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
            APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
            return
        }
        if imgLike.image ==  #imageLiteral(resourceName: "likeIcon-1") {
            addToWishList(productId: self.singleProduct?.product_id ?? "", customerId: customerId, sellerId: sellerId)
        }else {
            removeFromWishList(productId: (self.singleProduct?.product_id)!)
        }
      
    }
    
    @IBAction func btnViewMore(_ sender: Any) {
    }
    
    
    @IBAction func btnViewMoreDescription(_ sender: Any) {
        
        if let desc =  self.productWithDetail?.meta_description {
            descriptionView.frame = window.bounds
            window.addSubview(descriptionView)
            descriptionView.loadDescription(proDescription: desc)
        }
        
    }
    
    
    @IBAction func btnWeight(_ sender: UIButton) {
        selectProductOptions(sender: weightView)
    }
    
    @IBAction func btnQuantity(_ sender: UIButton) {
        if sender.tag == 0 {
            if count > 1 {
                count -= 1
                self.lblQuantity.text = "\(count)"
            }
        } else {
            count += 1
            self.lblQuantity.text = "\(count)"
        }
    }
    
    @IBAction func btnAddToCart(_ sender: UIButton) {

        
        guard let inventory = self.productWithDetail?.quantity else {
            APIManager.sharedInstance.customPOP(isError: true, message: "Out of stock")
            return
        }
        
        if (Int(inventory) ?? 0) >= Int(self.lblQuantity.text!)! {
            let productId = getProductId(product: self.singleProduct)
            _ = self.productWithDetail?.options?.first?.product_option_id
            if self.productWithDetail?.option_available == 1 {
                APIManager.sharedInstance.addToCartWithOption(productId: productId, productQuantiy: self.lblQuantity.text!, optionsValues: self.optionsParams)
            } else {
                APIManager.sharedInstance.addToCart(productId: productId, productQuantiy: self.lblQuantity.text!)
            }
        } else {
             APIManager.sharedInstance.customPOP(isError: true, message: "Out of stock")
        }
    }
    
    //Getting product id
    func getProductId(product: Product? ) -> String {
        if let id =  product?.product_id {
            return id
        }else if let id2 = product?.productId {
            return "\(id2)"
        }
        return "0"
    }
}





extension QProductVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.relatedProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QProductCell", for: indexPath) as! QProductCell
        if let product = self.relatedProducts?[indexPath.item] {
            cell.lblProductName.text = product.name
            if let price = product.price {
                let p = Double(price)?.round(to: 2)
                cell.lblPrice.text = "\(p!)"
            }
            

            if let url =  product.image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
                let resource = ImageResource(downloadURL:   URL(string: url)! , cacheKey: url)
                cell.imgProduct.kf.setImage(with: resource, placeholder: UIImage(named: IMAGE_PLACEHOLDER), options: [.transition(ImageTransition.fade(1))], progressBlock: { (recievedSize, totalSize) in
                }, completionHandler: nil)
            }
            
            
            cell.minus = {() -> Void in
                self.addToCartMinus(productId: product.product_id ?? "0", label: cell.lblCount ,index: indexPath.row)
            }
            
            cell.plus = {() -> Void in
                if (Int(product.quantity ?? "0")!) >= (Int(cell.lblCount.text!)!) {
                    self.addTeCartItemPlus(productId: product.product_id ?? "0", label: cell.lblCount ,index: indexPath.row)
                } else {
                    APIManager.sharedInstance.customPOP(isError: true, message: "Out of stock")
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = self.relatedProducts?[indexPath.item] {
            self.singleProduct = product
            getProductDetails(productId: product.product_id ?? "")
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
    
    
    
    // LOAD PRODUCT DETAILS
    func getProductDetails(productId: String)  {
        let params = [  "" :  "" ] as [String : AnyObject]
        let device_id  = APIManager.sharedInstance.getIsFirstTime()?.token ?? ""
        let language_id = APIManager.sharedInstance.getLanguage()!.id
        let seller_id = APIManager.sharedInstance.getStore()!.seller_id
      
        let url = PRODUCT_DETAILS + "product_id=\(productId)&device_id=\(device_id)&language=\(language_id)&seller_id=\(seller_id!)"
     
        WebServiceManager.get(params : params, serviceName: url, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Product Details", modelType: ProductInfo.self, success: { (response) in
            let data = (response as! ProductInfo)
            if data.msg?.lowercased() == "success" {
                guard let prod = data.result else {return}
                self.setProductData(product: prod)
                self.productWithDetail = data.result
//                if prod.option_available == "1" || prod.option_availableInt == 1 {
//                    self.varients = prod.options?.first?.product_option_value
//                    self.product_option_value_id = self.varients?.first?.product_option_value_id
//                    self.lblWeight.text = self.varients?.first?.name
//                }
            }
            else {
                //   APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
            }
            
        }) { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
    }
    
    
// loading related values
    func getSellerRelatedProducts(productId: String, sellerId: String, areaId:String)  {
        
        let params = [  "" :  "" ] as [String : AnyObject]
        var url = ""
        let language = APIManager.sharedInstance.getLanguage()!.id
        if APIManager.sharedInstance.getLocation().isLocation {
            let lat = APIManager.sharedInstance.getLocation().latitude
            let lng = APIManager.sharedInstance.getLocation().lngitude
            let rad = APIManager.sharedInstance.getLocation().radius
            url = GET_RELATED_PRODUCTS_BY_LOCATION + "product_id=\(productId)&language=\(language)&seller=\(sellerId)&lat=\(lat)&lng=\(lng)&radius=\(rad)&is_area=0&ios=1"
        }else {
            url = BASE_URL + "/index2.php?route=product/productapi/getSellerRelatedProducts&product_id=\(productId)&language=" + language + "&seller=\(sellerId)&area=\(areaId)&is_area=1&ios=1"
        }
        
        WebServiceManager.get(params : params, serviceName: url, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "Mian categories", modelType: FeaturedProducts.self, success: { (response) in
            let data = (response as! FeaturedProducts)
            if data.msg?.lowercased() == "success" {
                if data.relatedProducts?.count != 0 {
                    self.relatedProducts = data.relatedProducts?.first
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                }
            }else {
             //   APIManager.sharedInstance.customPOP(isError: true, message: data.msg ?? ERROR_MESSAGE)
            }
            
        }) { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }
    }
//

    // MARK:- ADD TO WISH LIST SERVICE
    
        func addToWishList(productId: String, customerId:String, sellerId: String)  {
            WebServiceManager.progressHudSetting()
              let city_Id  = APIManager.sharedInstance.getStore()?.city_id ?? ""
            SVProgressHUD.show()
            let params = [  "product_id"         : productId,
                            "customer_id"        : customerId,
                            "seller_id"          : sellerId,
                            "device_id"          : APIManager.sharedInstance.getIsFirstTime()!.token,
                            "ios"                 :"1",
                            "city_Id"            : city_Id
                ]
            Alamofire.request(ADD_TO_WISHLIST, method: .post, parameters: params).responseJSON { (response:DataResponse<Any>) in
                SVProgressHUD.dismiss()
                switch(response.result) {
                case .success(_):
                    let data = Mapper<Success>().map(JSONObject: response.result.value)
                    if data?.msg?.lowercased() == "success" {
                        self.imgLike.image = #imageLiteral(resourceName: "likedProduct")
                        APIManager.sharedInstance.customPOP(isError: false, message: data?.result ?? "Product Added In Wishlist" )
                    } else {
                        APIManager.sharedInstance.customPOP(isError: true, message: ERROR_MESSAGE )
                    }
                    break

                case .failure(_):
                    APIManager.sharedInstance.customPOP(isError: true, message: ERROR_MESSAGE)
                    break

                }

            }

        }
    

    
    //MARK:- REMOVE PRODUCT FORM WISH LIST
    
    func deleteProductFromWishList(productId: String, customerId : String) {
        
        let params = [  "product_id"    : productId,
                        "customer_id"   : customerId,
                        "ios"   :   "1"
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: DELETE_FROM_WISHLIST, header: header, serviceType: "User LogIn" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            if user.msg?.lowercased() == "success" {
                APIManager.sharedInstance.customPOP(isError: false, message: user.result ?? "Product Removed from Wishlist")
                self.imgLike.image =  #imageLiteral(resourceName: "likeIcon-1")
            } else {
                APIManager.sharedInstance.customPOP(isError: false, message: "Try again")
            }
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }, showHUD: true)
    }
    
    // MARK: - ADD TO CART SERVICE
    func addToCart(productId: String, customerId: String, sellerId:String, productQuantiy: String) {
        let deviceId = APIManager.sharedInstance.getIsFirstTime()!.token
        let lang    = APIManager.sharedInstance.getLanguage()!.id
        let params = [  "product_id"        : productId,
                        "product_quantity"  : productQuantiy,
                        "customer_id"       : customerId,
                        "seller_id"         : sellerId,
                        "device_id"         : deviceId,
                        "language_id"       : lang,
                        "ios"               : "1"
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: ADD_TO_CART, header: header, serviceType: "Add to cart" , modelType: Success.self, success: { (response) in
            let user = (response as! Success)
            if user.msg == "success" {
                APIManager.sharedInstance.customPOP(isError: false, message: "Product successfully added to cart")
                NotificationCenter.default.post(name: .getCart, object: nil)
                //                self.navigationController?.pushViewController(vc!, animated: true)
            }else {
                APIManager.sharedInstance.customPOP(isError: true, message: user.msg ?? ERROR_MESSAGE)
            }
            //
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
        }, showHUD: true)
    }
}
