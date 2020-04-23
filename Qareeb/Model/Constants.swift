//
//  Constants.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 16/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import Foundation

let  LANGUAGE_ID = "1"

let BASE_URL = "https://www.qareeb.com"
let IMAGE_BASE_URL = BASE_URL + "/image/"

//live
let PUBLIC_KEY = "pk_79a5860e-f7ba-466a-b339-5b0db8bfb751"
let SECRET_KEY = "sk_cf1fbb53-8204-4cd1-92e3-0e2f838d2834"

//sandbox
let SANBOX_PUBLIC_KEY = "pk_test_382c6532-c336-4e5c-a03d-79b369536eb1"
//let SANDBOX_PRIVATE_KEY = "sk_test_72933ea1-f5ae-45ce-af45-d06df67d8333"

//Checkout Payment Gateway
let CHECKOUT_PAYMENT_URL = "https://api2.checkout.com/v2/charges/token"
//let SANDBOX_CHECKOUT_PAYMENT_URL = "https://sandbox.checkout.com/api2/v2/charges/token"

//Arabic Fonts
let ARABIC_REGULAR = "DINNextLTArabic-Regular"

//English Fonts
let ENGLISH_REGULAR = "Montserrat-Regular"

let UPDATE_VERSION      = BASE_URL + "/index2.php?route=api/localisation/getStatus"

let SIGNUP              = BASE_URL + "/index2.php?route=account/ios_registerapiv3"
let VERIFY_OTP          = BASE_URL + "/index.php?route=account/validateUserApi"
let LOGIN               = BASE_URL + "/index.php?route=account/loginapi"
let SOCIALMEDIA_LOGIN   = BASE_URL + "/index2.php?route=api/sociallogin/fbLogin"

let FORGOT_PASSWORD     = BASE_URL + "/index.php?route=account/forgottenapi"

let CITIES              = BASE_URL + "/index.php?route=api/ios_localisation/getAllCities&language=" + APIManager.sharedInstance.getLanguage()!.id
let STORE_BY_AREA       = BASE_URL + "/index.php?route=api/localisation/getStoresByArea&language=" + APIManager.sharedInstance.getLanguage()!.id + "&areaId="
let STORE_BY_LOCATION   = BASE_URL + "/index2.php?route=api/ios_localisation/getStoresByCurrentLocation&"

let AREA_BY_CITY        = BASE_URL + "/index2.php?route=api/ios_localisation/getAreasByCityId&"
let MAIN_CATEGORIES     = BASE_URL + "/index2.php?route=product/ios_categoryapi/getStoreCategories"
let SUB_CATEGORIES      = BASE_URL + "/index2.php?route=product/categoryapi/getStoreSubCategories&"
let SPECIAL_PRODUCTS    = BASE_URL + "/index2.php?route=store/store/featureProduct&seller_id="

let PRODUCT_DETAILS     = BASE_URL + "/index2.php?route=product/productapi/getProductByDevice&"

let GET_PRODUCTS_BY_SUBCATEGORY_ID    = "http://3.18.249.87:3000/"

let HOME_PAGE_PRODUCTS    = BASE_URL + "/node_api/node_ios/webapi.php?apicall=getStoreHomeCategory&"

let SPECIAL_OFFERS      = BASE_URL + "/index.php?route=product/productapi/getWishlistV2&"

let WISH_LIST           = BASE_URL + "/index.php?route=product/productapi/getWishlistV2&customer_id="
let ADD_TO_WISHLIST     = BASE_URL + "/index.php?route=product/productapi/addToWishlistV2"
let DELETE_FROM_WISHLIST = BASE_URL + "/index.php?route=product/productapi/removeItemFromWishlistV2"

let ADD_TO_CART         = BASE_URL + "/index.php?route=product/productapi/addToCartV3"
let ADD_TO_CART_WITH_OPTION = BASE_URL + "/index.php?route=product/ios_productapi/addToCartV3"
let REMOVE_FROM_CART    = BASE_URL + "/index.php?route=product/productapi/removeItemFromCartV2"
let UPDATE_CART_ITEM    = BASE_URL + "/index.php?route=product/productapi/updateCartQuantityV2"

let GET_CART            = BASE_URL + "/index.php?route=product/productapi/getCartV2&"
let GET_ADDRESS         = BASE_URL + "/index.php?route=checkout/checkoutapi/getAllAddress&customer_id="

let DAYS_SLOTS          = BASE_URL + "/index.php?route=checkout/datetimeslot/daysSlots&"
let TIME_SLOTS_BY_DATE  = BASE_URL + "/index.php?route=checkout/datetimeslot/timeSlots&"

let NEXT_DELIVERY_SLOT  = BASE_URL + "/index2.php?route=product/productapi/getNextDeliverySlotByCartSeller&"

let ADD_ADDRESS         = BASE_URL + "/index.php?route=api/newAddress/add"

let APPLY_COUPON        = BASE_URL + "/index.php?route=product/productapi/couponDiscount"

//let PLACE_ORDER         = BASE_URL + "/index.php?route=checkout/confirmapi/confirmOrderV3"
//let PLACE_ORDER_MultiStore  = BASE_URL + "/index2.php?route=checkout/confirmapinew/confirmOrderV3New" // previous api

let PLACE_ORDER_MultiStore  = BASE_URL + "/index2.php?route=checkout/confirmapinewtest/confirmOrderV3New"
let PLACE_ORDER_PANDING_PAYMENT  = BASE_URL + "/index2.php?route=checkout/confirmapinewtest/confirmOrderV4"
let EMPTY_CART         = BASE_URL + "/index.php?route=product/ios_productapi/emptyCartV2"

let UPDATE_ORDER_STRATUS         = BASE_URL + "/index2.php?route=checkout/confirmapinew/confirmPaymentNotification"
let ORDER_HISTORY         = BASE_URL + "/index.php?route=account/orderapi&"
let ORDER_INFO         = BASE_URL + "/index.php?route=account/orderapi/info&"

let ACCOUNT             = BASE_URL + "/index.php?route=account/editapi/get_profile"

let ERROR_MESSAGE       = LocalizationSystem.shared.localizedStringForKey(key: "Something_went_wrong", comment: "")

let IMAGE_PLACEHOLDER   = "noImagePlaceholder-1"

let STORE_CREDIT_TRANSACTIONS   = BASE_URL + "/index.php?route=api/transaction/getAllTransactions"

let VALIDATE_STORE  = BASE_URL + "/index.php?route=account/orderapi/validateOrderProduct&"

let UPDATE_PROFILE = BASE_URL + "/index2.php?route=account/editapi/update_profile"


// Find store and other service by location

let FIND_STORE_BY_LOCATION   = BASE_URL + "/index.php?route=api/localisation/getStoresByCurrentLocation&"
let GET_CATEGORIES_BY_LOCATION   = BASE_URL + "/index.php?route=product/categoryapi/getStoreCategories&"
let GET_SUB_CATEGORIES_BY_LOCATION   = BASE_URL + "/index.php?route=product/categoryapi/getStoreSubCategories&"
let GET_SPECIAL_OFFERS_BY_LOCATION   = BASE_URL + "/index2.php?route=product/productapi/getSpecialProductsBySeller&"
let GET_RELATED_PRODUCTS_BY_LOCATION = BASE_URL + "/index.php?route=product/productapi/getSellerRelatedProducts&"

