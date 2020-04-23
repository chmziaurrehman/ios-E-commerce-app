//
//  StoreModel.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 18/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftKVC

class CitiesAndAreaModel : NSObject ,Mappable{
    
    var msg     : String?
    var resul   : String?
    var result  : [Results]?
    var banners : [BannerImage]?
    var mainCategories : [MainCatetogries]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        msg     <- map["msg"]
        resul  <- map["result"]
        result  <- map["result"]
        banners  <- map["banners"]
        mainCategories  <- map["result"]
    }
}

class BannerImage : NSObject ,Mappable{
    
    var image     : String?
    required init?(map: Map){ }
    override init() {
    }
    
    func mapping(map: Map) {
        image     <- map["image"]
    }
}

class Results : NSObject ,Mappable{
    // Area and city keye
    var city_id     : String?
    var name        : String?
    var name_ar     : String?
    var area_id     : String?
    
    
    //Store keys
    var seller_id       : String?
    var firstname       : String?
    var lastname        : String?
    var email           : String?
    var minimum_order   : String?
    var delivery_charges: String?
    var image           : String?
    var banner          : String?
    var time_content    : String?
    var time            : String?
    var store_status    : String?
    var rating          : String?
    
    //Location keys
    var longitude   : String?
    var latitude    : String?
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
         // Area and city keye
        city_id     <- map["city_id"]
        area_id     <- map["area_id"]
        name        <- map["name"]
        name_ar     <- map["name_ar"]
        
         //Store keys
        seller_id   <- map["seller_id"]
        firstname   <- map["firstname"]
        lastname    <- map["lastname"]
        email       <- map["email"]
        minimum_order       <- map["minimum_order"]
        delivery_charges    <- map["delivery_charges"]
        image               <- map["image"]
        banner              <- map["banner"]
        time_content        <- map["time_content"]
        time                <- map["time"]
        store_status        <- map["store_status"]
        rating              <- map["rating"]
        
        //Location keys
        longitude   <- map["longitude"]
        latitude    <- map["latitude"]
    }
}
class MainCatetogries : NSObject ,Mappable{
    var msg             : String?
    var category_id     : String?
    var image           : String?
    var name            : String?
    var next_delivery   : String?
    var desc            : String?
    var total_child     : String?
    
    required init?(map: Map){ }
    
    
    override init() {
        super.init()
    }
    
    convenience required init?(_ map: Map) {
        self.init()
    }
    
    
    
    func mapping(map: Map) {
        category_id     <- map["category_id"]
        image           <- map["image"]
        name            <- map["name"]
        next_delivery   <- map["name"]
        desc            <- map["description"]
        msg             <- map["msg"]
        total_child     <- map["total_child"]
    }
}


















class ProtectionModel: BaseRequestModel {
    var proId: String?
    var proValue: String?
    override init() {
        super.init()
    }
}

class BaseRequestModel : ListItem {
    
    var userName : String?
    var userId : String?
    var entityId : Int?
    var isValidate : Bool?
    var pdfFilePath : String?
}
class SexDataModel: BaseRequestModel {
    
    var sexId: String?
    var sexValue: String?
    
    
    override init() {
        super.init()
    }
    
    //    convenience required init?(sexID : String?, sexValue : String?) {
    //        self.init()
    //
    //        self.ID = itemID
    //        self.value = itemValue
    //    }
}
