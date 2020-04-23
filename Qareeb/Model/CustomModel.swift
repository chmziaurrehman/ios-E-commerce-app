//
//  CustomModel.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 23/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import Foundation

class StoreDefauls: NSObject, NSCoding {
    //User Id
    var customerId: String?
    var sellerId: String?
    var areaId: String?
    var cityId: String?
    var languageId: String? 

    init(customerId : String?, areaId: String?, cityId: String? ,languageId: String?, sellerId: String?) {
        
        self.customerId = customerId
        self.areaId = areaId
        self.cityId = cityId
        self.languageId = languageId
        self.sellerId = sellerId
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        
        let customerId = aDecoder.decodeObject(forKey: "customerId") as? String
        let areaId = aDecoder.decodeObject(forKey: "areaId") as? String
        let cityId = aDecoder.decodeObject(forKey: "cityId") as? String
        let languageId = aDecoder.decodeObject(forKey: "languageId") as? String
        let sellerId = aDecoder.decodeObject(forKey: "sellerId") as? String
        
        self.init(customerId: customerId , areaId: areaId, cityId: cityId, languageId: languageId, sellerId:sellerId)
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(customerId, forKey: "customerId")
        aCoder.encode(areaId, forKey: "areaId")
        aCoder.encode(cityId, forKey: "cityId")
        aCoder.encode(languageId, forKey: "languageId")
        aCoder.encode(sellerId, forKey: "sellerId")

    }
}
