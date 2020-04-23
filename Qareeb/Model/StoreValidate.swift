//
//  StoreValidate.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 08/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper

class StoreValidate : NSObject ,Mappable{
    
    var storeExist      : Bool?
    var productExist    : Bool?
    var seller          : Results?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        storeExist      <- map["storeExist"]
        productExist    <- map["productExist"]
        seller          <- map["seller"]
        
    }
}
