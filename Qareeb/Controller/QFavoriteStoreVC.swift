//
//  QFavoriteStoreVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 18/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import SwiftKVC
import ObjectMapper
import Kingfisher
import CoreLocation
import DropDown

class QFavoriteStoreVC: UIViewController{
    
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    var isSelected: UrlType!
    var cityId =  ""
    var areaId = ""
    let apgar = [("Select","0"),("01","01"),("02","02"),("03","03"),("04","04"),("05","05"),("06","06"),("07","07"),("08","08"),("09","09"),("10","10")]
    var stores: [Results]?
    var banners: [BannerImage]?
    var cities: [Results]?
    var areas: [Results]?
    let dropDown = DropDown()
    weak var lblcity: UILabel!
    weak var lblArea: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var noDataAvailable: UIView!
    var refreshControl: UIRefreshControl = UIRefreshControl()

    @IBOutlet weak var lblChangeBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        refreshControl.tintColor = APIManager.sharedInstance.firstColor
        refreshControl.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        refreshControl.attributedTitle = NSAttributedString(string: "Loading Store", attributes: [NSAttributedString.Key.foregroundColor : APIManager.sharedInstance.firstColor])
        
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        
        // Regiter Store Cell
        collectionView.register(UINib(nibName: "QStoreCell", bundle: nil), forCellWithReuseIdentifier: "QStoreCell")
        collectionView.register(UINib(nibName: "QStoreHeaderCell", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "QStoreHeaderCell")

        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        layout.itemSize = CGSize(width: (screenWidth/2) - 22, height: 210)
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        collectionView!.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self

        localizeStrings()
   
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        APIManager.sharedInstance.getAddress { (address) in
            self.txtSearch.text = address
        }
    }
    
    override func viewDidLayoutSubviews() {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        callingServicesForStore()
    }
  
    
    //Localization configrations
    func localizeStrings() {
        lblChangeBtn.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "change", comment: ""), for: .normal)
        title = LocalizationSystem.shared.localizedStringForKey(key: "select_store", comment: "")
        
    }
    
    func callingServicesForStore() {
        if !APIManager.sharedInstance.getLocation().isLocation {
            if let savedCityId = APIManager.sharedInstance.getCityAndArea()?.cityId , let savedAreaId = APIManager.sharedInstance.getCityAndArea()?.areaId {
                self.areaId = savedAreaId
                self.cityId = savedCityId
                self.getCitiesAndArea(.Store)
            }
        }else {
            self.getCitiesAndArea(.Location)
        }
    }
    
    
    @objc func refresh() {
       callingServicesForStore()
    }
    
    //MARK:- BUTTON ACTION
    @IBAction func btnChange(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "WAPickUpLocation") as! WAPickUpLocation
        self.navigationController?.pushViewController(vc, animated: true)

      
    }


}

extension QFavoriteStoreVC:  UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.stores?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QStoreCell", for: indexPath) as! QStoreCell
      
        guard let limit = self.stores?[indexPath.item].minimum_order else {  return cell }
        guard let rating = self.stores?[indexPath.item].rating else {  return cell }
        
        if APIManager.sharedInstance.getLanguage()!.id == "1" {
            cell.lblStoreName.text = self.stores?[indexPath.item].firstname
            cell.lblLimit.text = "Min Limit: \(limit) SR"
        }else {
            cell.lblStoreName.text = self.stores?[indexPath.item].lastname
            cell.lblLimit.text = " الحد الأدنى\( limit ) ريال"
        
        }
        
        
        cell.ratingView.rating = Double(rating) ?? 0.0
        cell.lblTimeSlot.text = self.stores?[indexPath.item].time_content
        if self.stores?[indexPath.item].store_status?.lowercased() != "close" {
            cell.lblStatus.text = "OPEN"
            cell.lblStatusColor.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }else {
            cell.lblStatus.text = "CLOSED"
            cell.lblStatusColor.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        }
        
        if let url =  self.stores?[indexPath.item].image?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            let resource = ImageResource(downloadURL: URL(string: url)!, cacheKey: url)
            cell.imgStore.kf.setImage(with: resource, placeholder: nil, options: [.transition(ImageTransition.fade(1))], progressBlock: { (recievedSize, totalSize) in
            }, completionHandler: nil)
        }
        if let url =  self.stores?[indexPath.item].banner?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            let resource = ImageResource(downloadURL:  URL(string: url)!, cacheKey: url)
            cell.imgBackground.kf.setImage(with: resource, placeholder: UIImage(named: IMAGE_PLACEHOLDER), options: [.transition(ImageTransition.fade(1))], progressBlock: { (recievedSize, totalSize) in
            }, completionHandler: nil)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storeData = self.stores?[indexPath.item]
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QTabbarNavigationController") as! QTabbarNavigationController
        APIManager.sharedInstance.storeInfo = storeData

        var savedStore = APIManager.sharedInstance.getStore()
        savedStore?.seller_id           = storeData?.seller_id
        savedStore?.city_id             = storeData?.city_id
        savedStore?.firstname           = storeData?.firstname
        savedStore?.lastname            = storeData?.lastname
        savedStore?.email               = storeData?.email
        savedStore?.minimum_order       = storeData?.minimum_order
        savedStore?.delivery_charges    = storeData?.delivery_charges
        savedStore?.image               = storeData?.image
        savedStore?.banner              = storeData?.banner
        savedStore?.time_content        = storeData?.time_content
        savedStore?.time                = storeData?.time
        savedStore?.store_status        = storeData?.store_status
        savedStore?.rating              = storeData?.rating
        savedStore?.latitude            = storeData?.latitude
        savedStore?.longitude           = storeData?.longitude

        APIManager.sharedInstance.setStore(in: savedStore  ?? Store())

        window.rootViewController = vc
        window.makeKeyAndVisible()
//        self.present(vc, animated: true, completion: nil)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = false
        
        return CGFloat(0)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let reusableview = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "QStoreHeaderCell", for: indexPath) as! QStoreHeaderCell
            dropDown.anchorView = reusableview
            self.dropDown.bottomOffset = CGPoint(x: 0, y: 60)

            reusableview.selectCity = {(sender) -> Void in
                self.getCitiesAndArea(.City)
                self.lblArea = reusableview.lblArea
                self.isSelected = UrlType.City
            }
            reusableview.selectArea = {() -> Void in
                self.isSelected = UrlType.Area
                self.lblcity = reusableview.lblCity
                if self.cityId != "" {
                 self.getCitiesAndArea(.Area)
                }else {
                    APIManager.sharedInstance.customPOP(isError: true, message: "Please select a city")
                }
            }
            
            
            
            self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                if self.isSelected == UrlType.City {
                    self.cityId = (self.cities?[index].city_id)!
                    reusableview.lblCity.text = self.cities?[index].name
                    
                }else {
                    self.areaId = (self.areas?[index].area_id)!
                    reusableview.lblArea.text =  self.areas?[index].name
                    
                    var areaAndCity = APIManager.sharedInstance.getCityAndArea()
                    areaAndCity?.areaId = self.areaId
                    areaAndCity?.areaName = self.areas?[index].name
                    areaAndCity?.cityId = self.cityId
                    areaAndCity?.cityName = reusableview.lblCity.text
                    APIManager.sharedInstance.setCityAndArea(in: areaAndCity ?? CityAndArea())
                    
                    var loc = APIManager.sharedInstance.getLocation()
                        loc.isLocation = false
                        APIManager.sharedInstance.setLocation(in: loc)
                    
                    self.getCitiesAndArea(.Store)
                }
            }
            
            if let bannerImages = self.banners {
                reusableview.bannerView.setBanner(banners: bannerImages)
            }
            
            return reusableview
            
        default:  fatalError("Unexpected element kind")
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if self.banners?.count != 0 && self.stores?.count != 0 {
            return CGSize(width: collectionView.frame.width, height: 160)
        }
         return CGSize(width: collectionView.frame.width, height: 60)
    }
    
    
    
    
    
    
    // MARK:- WEB SERVICES
    
    func getCitiesAndArea(_ type: UrlType) {
        let idofAppointmet = [ "": "" ] as [String : AnyObject]
        var url: String!
        
        switch type {
            
        case .City:
            url = CITIES
        case .Area:
            url = AREA_BY_CITY + "cityId=" + cityId + "&language=" + APIManager.sharedInstance.getLanguage()!.id
        case .Store:
            self.stores?.removeAll()
            self.collectionView.reloadData()
            self.noDataAvailable.isHidden = false
            url = STORE_BY_AREA + areaId
        case .Location:
            self.stores?.removeAll()
            self.collectionView.reloadData()
            self.noDataAvailable.isHidden = false
            let lat = APIManager.sharedInstance.getLocation().latitude
            let lng = APIManager.sharedInstance.getLocation().lngitude
            let rad = APIManager.sharedInstance.getLocation().radius
            url = FIND_STORE_BY_LOCATION + "lat=\(lat)&lng=\(lng)&radius=" + rad + "&language=" + APIManager.sharedInstance.getLanguage()!.id
        }
        
        WebServiceManager.get(params : idofAppointmet, serviceName: url, header: ["Content-Type": "application/x-www-form-urlencoded"], serviceType: "FIND CITIES / AREA / STORE / STORE BY LOCATION", modelType: CitiesAndAreaModel.self, success: { (response) in
            let data = (response as! CitiesAndAreaModel)
            self.refreshControl.endRefreshing()
            if data.msg?.lowercased() == "success" {
                switch type {
                case .City:
                    self.cities = data.result
                    if let cities = data.result?.map({$0.name}) {
                        self.dropDown.dataSource = cities as! [String]
                        self.dropDown.show()
                    }
                case .Area:
                    self.areas = data.result
                    if let areas = data.result?.map({$0.name}) {
                        self.dropDown.dataSource = areas as! [String]
                        self.dropDown.show()
                    }
                case .Store,.Location:
                    self.stores = data.result
                    self.banners = data.banners
                    self.collectionView.dataSource = self
                    self.collectionView.delegate = self
                    self.collectionView.reloadData()
                    
                    if self.stores?.count != 0 && self.stores != nil {
                        self.noDataAvailable.isHidden = true
                    }else {
                        self.noDataAvailable.isHidden = false
                    }
                }
            }else {
            }
            
        }) { (error) in
        }
    }

}
