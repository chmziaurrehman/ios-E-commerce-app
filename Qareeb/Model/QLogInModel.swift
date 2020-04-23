//
//  QLogInModel.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 16/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper


class UpdateProfile : NSObject ,Mappable{
    
    var     status: String?
    var     msg : String?
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        status     <- map["status"]
        msg     <- map["msg"]
    }
}


class Success : NSObject ,Mappable{
    
    var     msg: String?
    var     message: String?
    var     result : String?
    var     responseAdvancedInfo: String?
    var     responseMessage: String?
    
    var id : String?
    var liveMode : Bool?
    var chargeMode : Int?
    var responseCode : String?
    var redirectUrl : String?
    var trackId : String?
    var enrolled : String?

    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        msg     <- map["msg"]
        message     <- map["message"]
        result     <- map["result"]
        responseAdvancedInfo     <- map["responseAdvancedInfo"]
        responseMessage     <- map["responseMessage"]
        
        id <- map["id"]
        liveMode <- map["liveMode"]
        chargeMode <- map["chargeMode"]
        responseCode <- map["responseCode"]
        redirectUrl <- map["redirectUrl"]
        trackId <- map["trackId"]
        enrolled <- map["enrolled"]
    }
}


class UserModel : NSObject ,Mappable{
    
    var success: Bool?
    
    var message: String?
    var result : String?
    var customer_info: CustomerInfo?
    var customer : CustomerInfo?
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        
        customer        <- map["customer"]
        message         <- map["message"]
        message         <- map["msg"]
        result         <- map["result"]
        customer_info   <- map["customer_info"]
        customer_info   <- map["customer"]
        success         <- map["success"]

    }
}
class CustomerInfo : NSObject ,Mappable{
   
    var message: String?
    var msg : String?
    var customer_id: String?
    var customer_group_id: String?
    var store_id: String?
    var firstname: String?
    var lastname: String?
    var email: String?
    var telephone: String?
    var fax: String?
    var password: String?
    var salt: String?
    var cart: String?
    var wishlist: String?
    var newsletter: String?
    var address_id: String?
    var address: String?
    var city: String?
    var custom_field: String?
    var ip: String?
    var status: String?
    var approved: String?
    var safe: String?
    var token: String?
    var date_added: String?
    var code: String?
    var mobile_user_id: String?
    var mobile_reg_id: String?
    var sentPassword:  String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        
        message         <- map["message"]
        msg             <- map["msg"]
        customer_id     <- map["customer_id"]
        customer_group_id      <- map["customer_group_id"]
        store_id        <- map["store_id"]
        firstname       <- map["firstname"]
        lastname        <- map["lastname"]
        email           <- map["email"]
        telephone       <- map["telephone"]
        fax             <- map["fax"]
        password        <- map["password"]
        salt            <- map["salt"]
        cart            <- map["cart"]
        wishlist        <- map["wishlist"]
        newsletter      <- map["newsletter"]
        address_id      <- map["address_id"]
        address         <- map["address"]
        city            <- map["city"]
        custom_field    <- map["custom_field"]
        ip              <- map["ip"]
        status          <- map["status"]
        approved        <- map["approved"]
        safe            <- map["safe"]
        token           <- map["token"]
        date_added      <- map["date_added"]
        code            <- map["code"]
        mobile_user_id  <- map["mobile_user_id"]
        mobile_reg_id   <- map["mobile_reg_id"]
        sentPassword    <- map["sentPassword"]
    }
}

