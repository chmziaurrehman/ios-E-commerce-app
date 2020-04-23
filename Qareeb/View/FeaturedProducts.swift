//
//  FeaturedProducts.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 20/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper

class FeaturedProducts : NSObject ,Mappable{
    var msg     : String?
    var message     : String?
    var status : Bool?
    var products  : [Product]?
    var title   : String?
    var specialOffers  : [Product]?
    var category_id : String?
    var name  : String?
    var result : [Product]?
    var relatedProducts : [[Product]]?
    var subProducts : [[Product]]?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        status <- map["status"]
        message         <- map["message"]
        msg         <- map["msg"]
        title       <- map["title"]
        category_id <- map["category_id"]
        name        <- map["name"]
        products    <- map["products"]
        result      <- map["result"]
        relatedProducts <- map["result"]
        subProducts <- map["products"]
    }
}
class Product : NSObject ,Mappable{
    
    var status          : String?
    var product_id      : String?
    var productId       : Double?
    var quantity        : String?
    var quantityInt     : Double?
    var price           : String?
    var priceNew        : Double?
    var meta_description: String?
    var name            : String?
    var image           : String?
    var images          : [String]?
    var discount        : String?
    var special         : String?
    var specialNew      : Double?
    var product_in_cart : String?
    var in_wishlist     : Int?
    var stock_status    : String?
    var thumb           : String?
    var desc            : String?
    var specialPro      : String?
    var tax             : Bool?
    var minimum         : String?
    var rating          : String?
    var options         : [Options]?
    var option_available: Int?
    
    
    //WishList keys
    var seller_id   : String?
    var firstname   : String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        status              <- map["status"]
        product_id          <- map["product_id"]
        productId           <- map["product_id"]
        quantity            <- map["quantity"]
        quantityInt         <- map["quantity"]
        price               <- map["price"]
        priceNew            <- map["price"]
        meta_description    <- map["meta_description"]
        name                <- map["name"]
        image               <- map["image"]
        images              <- map["image"]
        discount            <- map["discount"]
        special             <- map["special"]
        specialNew          <- map["special"]
        product_in_cart     <- map["product_in_cart"]
        in_wishlist         <- map["in_wishlist"]
        stock_status        <- map["stock_status"]
        option_available    <- map["option_available"]
        
        thumb       <- map["thumb"]
        thumb       <- map["thumb"]
        desc        <- map["description"]
        specialPro     <- map["special"]
        tax         <- map["tax"]
        minimum     <- map["minimum"]
        rating      <- map["rating"]
        options     <- map["options"]
        
        //WishList Keys
        seller_id   <- map["seller_id"]
        firstname   <- map["firstname"]
    }
}
