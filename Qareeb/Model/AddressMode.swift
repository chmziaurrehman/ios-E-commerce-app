//
//  AddressMode.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 26/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftKVC

class AddressModel : NSObject ,Mappable{
    
    var msg     : String?
    var slot : String?
    var error   : String?
    var address_id : Int?
    var result  : [AddressResults]?
    var slots  : [Slots]?
    var timeSlots : [String]?
    var timeSlotsWithDats : [String]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        msg     <- map["msg"]
        slot     <- map["timeSlot"]
        error   <- map["error"]
        address_id  <- map["address_id"]
        result      <- map["result"]
        
        // Days slots
        slots   <- map["slots"]
        timeSlots <- map["times"]
        timeSlotsWithDats <- map["slots"]
        
    }
}

class AddressResults : NSObject ,Mappable{
    // Area and city keye
    var address_id     : String?
    var firstname        : String?
    var lastname     : String?
    var company     : String?
    var address_1   : String?
    var address_2   : String?
    var postcode    : String?
    var city        : String?
    var zone_id     : String?
    var zone        : String?
    var zone_code   : String?
    var country_id  : String?
    var country     : String?
    var iso_code_2  : String?
    var iso_code_3  : String?
    var address_format  : String?
    var custom_field    : Bool?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {

        address_id  <- map["address_id"]
        firstname   <- map["firstname"]
        lastname    <- map["lastname"]
        company     <- map["company"]
        address_1   <- map["address_1"]
        address_2   <- map["address_2"]
        postcode    <- map["postcode"]
        city        <- map["city"]
        zone_id     <- map["zone_id"]
        zone        <- map["zone"]
        zone_code   <- map["zone_code"]
        country_id  <- map["country_id"]
        country     <- map["country"]
        iso_code_2  <- map["iso_code_2"]
        iso_code_3  <- map["iso_code_3"]
        address_format  <- map["address_format"]
        custom_field    <- map["custom_field"]
    }
}

class Slots : NSObject ,Mappable{
    
    var value   : String?
    var name    : String?
    var date    : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        value     <- map["value"]
        name   <- map["name"]
        date  <- map["date"]
    }
}
