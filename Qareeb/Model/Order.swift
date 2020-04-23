//
//  Order.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 25/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper

class Order : NSObject ,Mappable{
    
    var order_id        : String?
    var name            : String?
    var status          : String?
    var order_status_id : String?
    var date_added      : String?
    var products        : Int?
    var total           : String?
    var seller_name     : String?
    var seller_id       : String?
    
    // Order Info
    var delivery_date_time : Delivery_date_time?
    var payment_address : String?
    var payment_method : String?
    var shipping_address : String?
    var shipping_method : String?
    var OrderProducts : [OrderProducts]?

    required init?(map: Map){ }
    
    func mapping(map: Map) {
        order_id        <- map["order_id"]
        name            <- map["name"]
        status          <- map["status"]
        order_status_id <- map["order_status_id"]
        date_added      <- map["date_added"]
        products        <- map["products"]
        total           <- map["total"]
        seller_name     <- map["seller_name"]
        seller_id       <- map["seller_id"]
        payment_address <- map["payment_address"]
        payment_method  <- map["payment_method"]
        shipping_address    <- map["shipping_address"]
        shipping_method     <- map["shipping_method"]
        OrderProducts     <- map["products"]
        delivery_date_time     <- map["delivery_date_time"]

    }
}



class Delivery_date_time : NSObject ,Mappable{
    
    var time        : String?
    var date            : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        time        <- map["time"]
        date            <- map["date"]
    }
}

class OrderProducts : NSObject ,Mappable{
    
    var id          : String?
    var name        : String?
    var model       : String?
    var quantity    : String?
    var upc         : String?
    var price       : String?
    var image       : String?
    var total       : String?
    var reorder     : String?
    var ret         : String?
    var seller_name : String?
    var seller_id   : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        id          <- map["id"]
        name        <- map["name"]
        model       <- map["model"]
        upc         <- map["upc"]
        quantity    <- map["quantity"]
        price       <- map["price"]
        image       <- map["image"]
        total       <- map["total"]
        reorder     <- map["reorder"]
        ret         <- map["return"]
        seller_name <- map["seller_name"]
        seller_id   <- map["seller_id"]
        
    }
}







class ConfirmOrder : NSObject ,Mappable{
    var msg     :String?
    var message : Bool?
    var orderid : String?
    var total   : Double?
    var payment_firstname  : String?
    var payment_lastname   : String?
    var email           : String?
    var telephone       : String?
    var address_1       : String?
    var address_2       : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        msg             <- map["message"]
        message         <- map["message"]
        orderid         <- map["orderid"]
        orderid         <- map["orders_id"]
        total           <- map["total"]
        payment_firstname   <- map["payment_firstname"]
        payment_lastname    <- map["payment_lastname"]
        email           <- map["email"]
        telephone       <- map["telephone"]
        address_1       <- map["address_1"]
        address_2       <- map["address_2"]
    }
}
