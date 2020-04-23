//
//  CouponModel.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 13/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper

class CouponModel : NSObject ,Mappable{
    
    var msg     : String?
    var result  : [CouponResult]?
    var resultMsg  : CouponResult?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        msg      <- map["msg"]
        result    <- map["result"]
        resultMsg    <- map["result"]
    }
}

class CouponResult : NSObject ,Mappable{
    var msg         : String?
    var code        : String?
    var title       : String?
    var value       : Double?
    var sort_order  : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        msg         <- map["msg"]
        code        <- map["code"]
        title       <- map["title"]
        value       <- map["value"]
        sort_order  <- map["sort_order"]
    }
}

class AppVersion : NSObject ,Mappable{
    
    var config_android_app_url      : String?
    var config_android_app_version  : String?
    var config_api_status           : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        config_android_app_url          <- map["config_android_app_url"]
        config_android_app_version      <- map["config_android_app_version"]
        config_api_status               <- map["config_api_status"]
    }
}
