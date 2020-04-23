//
//  StoringData.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 27/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation

struct Store: Codable {
    
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
    var longitude       : String?
    var latitude        : String?
    var city_id         : String?
    
}

struct CityAndArea: Codable {
    var cityName    : String?
    var cityId      : String?
    var areaName    : String?
    var areaId      : String?
}
struct StoreByLocation  : Codable {
    var latitude    = DEVICE_LAT
    var lngitude    = DEVICE_LONG
    
    var radius      = "20"
    var isLocation  = false
}
struct Languages: Codable {
    var id  = "1"
    var code = "en"
}
struct updateOrderStatus: Codable {
    var orderIds: [String]?
}
struct IsFirstTime: Codable {
    var id  = "0"
    var token = ""
}
struct Customer: Codable {
    
    var customer_id         : String?
    var customer_group_id   : String?
    var store_id            : String?
    var firstname           : String?
    var lastname            : String?
    var email               : String?
    var telephone           : String?
    var fax                 : String?
    var password            : String?
    var salt                : String?
//    var cart              : String?
//    var wishlist          : String?
    var newsletter          : String?
    var address_id          : String?
    var custom_field        : String?
    var ip                  : String?
    var status              : String?
    var approved            : String?
    var safe                : String?
    var token               : String?
    var date_added          : String?
    var code                : String?
    var mobile_user_id      : String?
    var mobile_reg_id       : String?
    
}

extension UserDefaults {
    func set<T: Encodable>(encodable: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(encodable) {
            set(data, forKey: key)
        }
    }
    func value<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        if let data = object(forKey: key) as? Data,
            let value = try? JSONDecoder().decode(type, from: data) {
            return value
        }
        return nil
    }
}


enum SearchBy: String {
    case Name
    case Id
}


enum UrlType: String {
    case City
    case Area
    case Store
    case Location
}

enum OrderStatus: String {
    case Placed
    case Accepted
    case Shopping
    case OnTheWay
    case Delivered
}

struct FacebookModel {
    var firstname: String?
    var lastname : String?
    var email: String?
    init(fname: String, lname: String, emailId:String) {
        firstname = fname
        lastname = lname
        email = emailId
    }
}
