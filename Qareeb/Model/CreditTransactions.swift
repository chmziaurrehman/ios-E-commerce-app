//
//  CreditTransections.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 05/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation
import ObjectMapper

class CreditTransactions : NSObject ,Mappable{
    
    var msg     : String?
    var result  : Transactions?
    var total_amount: String?
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        msg     <- map["msg"]
        result      <- map["result"]
        total_amount <- map["total_amount"]
    }
}
class Transactions : NSObject ,Mappable{
    var transactions     : [Detail]?
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        transactions     <- map["transactions"]
    }
}
class Detail : NSObject ,Mappable{
    var amount     : String?
    var desc     : String?
    var date_added     : String?
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        amount          <- map["amount"]
        desc            <- map["description"]
        date_added      <- map["date_added"]
    }
}
