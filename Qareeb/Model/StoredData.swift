//
//  StoredData.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 17/11/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation

enum FONT: String {
    //English Fonts
    case enRegular  = "Montserrat-Regular"
    case enLight    = "Montserrat-Light"
    case enBold     = "Montserrat-Bold"
    case enSemiBold = "Montserrat-SemiBold"
    //Arabic Fonts
    case arRegular  = "DINNextLTArabic-Regular"
    case arLight    = "DINNextLTArabic-Light"
    case arBold     = "DINNextLTArabic-Bold"
    case arSemiBold = "DINNextLTArabic-Medium"
}

enum SIZE: Int {
    case extraBig       = 26
    case big            = 23
    case semibig        = 14
    case regular        = 12
    case semiRegular    = 10
    case light          = 8
}

class Language: NSObject {
    class func value(key: String) -> String {
        return LocalizationSystem.shared.localizedStringForKey(key: key, comment: "")
    }
}
