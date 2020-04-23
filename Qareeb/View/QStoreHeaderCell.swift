//
//  QStoreHeaderCell.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 18/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire

class QStoreHeaderCell: UICollectionReusableView {

    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblArea: UILabel!
    @IBOutlet weak var bannerView: ImageSlideshow!
    
    var selectCity:((_ sender : UIButton)-> Void)!
    var selectArea:(()-> Void)!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Search By Location
        if APIManager.sharedInstance.getLocation().isLocation {
            localizeStrings(language: APIManager.sharedInstance.getLanguage()!.code)
        }else  {
            //Search By City and Area 
            if let city = APIManager.sharedInstance.getCityAndArea()?.cityName , let area = APIManager.sharedInstance.getCityAndArea()?.areaName {
                lblArea.text = area
                lblCity.text = city
            }
        }
        
    }
    
    //Localization configrations
    func localizeStrings(language: String) {
        lblCity.text = LocalizationSystem.shared.localizedStringForKey(key: "selectCity", comment: "")
        lblArea.text = LocalizationSystem.shared.localizedStringForKey(key: "selectArea", comment: "")
    }
    
    @IBAction func btnArea(_ sender: Any) {
        self.selectArea()
    }
    @IBAction func btnCity(_ sender: UIButton) {
        self.selectCity(sender)
    }
    
//    func setBanner(banners: [BannerImage])  {
//        var sorces = [AlamofireSource]()
//        for  i in 0..<banners.count {
//            if let url = banners[i].image {
//                sorces.append(AlamofireSource(urlString: IMAGE_BASE_URL + url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
//            }
//        }
//        DispatchQueue.main.async {
//            self.bannerView.slideshowInterval = 4.0
//            self.bannerView.contentMode = .scaleToFill
//            self.bannerView.contentScaleMode = .scaleAspectFill
//            self.bannerView.setImageInputs(sorces)
//        }
//    }
}


