//
//  File.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 23/04/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper

class ProductInfo : NSObject ,Mappable{
    
    var msg     : String?
    var result  : Product?
    var resultMsg  : CouponResult?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        msg      <- map["msg"]
        result    <- map["result"]
    }
}

class Options : NSObject ,Mappable{
    
    var name                    : String?
    var option_id               : String?
    var product_option_id       : String?
    var product_option_value    : [Product_option_value]?
    var required                : String?
    var type                    : String?
    var value                   : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        name                    <- map["name"]
        option_id               <- map["option_id"]
        product_option_id       <- map["product_option_id"]
        product_option_value    <- map["product_option_value"]
        required                <- map["required"]
        type                    <- map["type"]
        value                   <- map["value"]
    }
}

class Product_option_value : NSObject ,Mappable{
    
    var product_option_value_id : String?
    var option_value_id         : String?
    var name                    : String?
    var price                   : String?
    var price_prefix            : String?
    var image                   : String?
    var isSelected              = false
    
    override init() {
        
    }
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        product_option_value_id <- map["product_option_value_id"]
        option_value_id         <- map["option_value_id"]
        name <- map["name"]
        price         <- map["price"]
        option_value_id         <- map["option_value_id"]
        price_prefix <- map["price_prefix"]
        image         <- map["image"]
    }
}
