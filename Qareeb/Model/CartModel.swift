//
//  CartModel.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 25/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper

class MultiSellerCart : NSObject ,Mappable{
    
    var msg         : String?
    var result      : [SellerResult]?
    var resultMsg   : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        msg     <- map["msg"]
        result  <- map["result"]

    }
}


class SellerResult : NSObject ,Mappable{
    
    var seller_id         : Int?
    var name_En : String?
    var name_Ar : String?
    var delivery_charges      : Int?
    var minimum_order   : Int?
    var total: Double?
    var store_credit: String?
    var products : [CartModel]?
    var free_delivery_order_limit : Int?
    var seller_grand_total: Double?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        seller_id           <- map["seller_id"]
        name_En             <- map["seller_nameen"]
        name_Ar             <- map["seller_namear"]
        delivery_charges    <- map["delivery_charges"]
        minimum_order       <- map["minimum_order"]
        total               <- map["seller_total"]
        store_credit        <- map["store_credit"]
        free_delivery_order_limit   <- map["free_delivery_order_limit"]
        seller_grand_total   <- map["seller_grand_total"]
        products            <- map["products"]
        
    }
}

class CartModel : NSObject ,Mappable{
    
    var seller_id   : String?
    var seller      : String?
    var cart_id     : String?
    var product_id  : String?
    var name        : String?
    var model       : String?
    var shipping    : String?
    var image       : String?
    var quantity    : String?
    var minimum     : String?
    var stock       : Bool?
    var price       : Double?
    var special     : Double?
    var total       : Double?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        seller_id       <- map["seller_id"]
        cart_id         <- map["cart_id"]
        seller          <- map["seller"]
        product_id      <- map["product_id"]
        name            <- map["name"]
        model           <- map["model"]
        shipping        <- map["shipping"]
        image           <- map["image"]
        quantity        <- map["quantity"]
        minimum         <- map["minimum"]
        stock           <- map["stock"]
        price           <- map["price"]
        special         <- map["special"]
        total           <- map["total"]
    }
}
