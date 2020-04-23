//
//  CheckoutKit.swift
//  CheckoutKit
//
//  Created by Manon Henrioux on 13/08/2015.
//  Copyright (c) 2015 Checkout.com. All rights reserved.
//

import Foundation

/** Main class allowing to create one CheckoutKit instance, provide the merchant's public key and create card tokens */

open class CheckoutKit {
    
    open let PUBLIC_KEY_REGEX_VALIDATION: String = "^pk_(?:test_)?(?:\\w{8})-(?:\\w{4})-(?:\\w{4})-(?:\\w{4})-(?:\\w{12})$"
    
    fileprivate static var ck: CheckoutKit? = nil
    
    var pk: String!
    var env: Environment
    var logging: Bool
    var logger: Log
    
    /*
    
    Enumeration containing the basic definition of the avaiable REST functions
    
    */
    
    enum RESTFunction: String {
        case GETCARDPROVIDERS = "providers/cards"
        case CREATECARDTOKEN = "tokens/card"
    }
    
    /*
    
    Private constructor used for the Singleton Pattern
    
    @param pk String containing the merchant's public key
    
    @param env Environment object containing the information of the merchant's environment, default is SANDBOX
    
    @param debug boolean, if the debug mode is activated or not, default is true
    
    @param logger Log instance for logging purposes if debug mode is activated
    
    @throws CheckoutError if an error occurs or the public key is invalid
    
    */
    
    fileprivate init(pk: String, env: Environment, debug: Bool, logger: Log) throws {
        self.env = env
        self.logging = debug
        self.logger = logger

        if !Regex(pattern: PUBLIC_KEY_REGEX_VALIDATION).matches(pk) {
            logger.info("**Wrong public key**   \(pk)")
            throw CheckoutError.invalidPK
        }
        self.pk = pk
        if(self.logging){
            self.logger.info("**CheckoutKit created**   \(pk)")
        }
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    @param pk String containing the merchant's public key
    
    @param env Environment object containing the information of the merchant's environment, default is SANDBOX
    
    @param debug boolean, if the debug mode is activated or not, default is true
    
    @param logger Log instance for logging purposes if debug mode is activated
    
    @throws CheckoutError if an error occurs or the public key is invalid
    
    */
    
    open class func getInstance(_ pk: String, env: Environment, debug: Bool, logger: Log) throws -> CheckoutKit? {
        if (ck == nil) {
            ck = try CheckoutKit(pk: pk, env: env, debug: debug, logger: logger)
        }
        return ck
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    @param pk String containing the merchant's public key
    
    @throws CheckoutError if an error occurs or the public key is invalid
    
    */
    
    open class func getInstance(_ pk: String) throws -> CheckoutKit? {
        if (ck == nil) {
            ck = try CheckoutKit(pk: pk, env: Environment.LIVE, debug: true, logger: Log.getLog())
        }
        return ck
    }
    
    
    /**

    Function used for the Singleton Pattern, returns a unique CheckoutKit instance, to be used once the CheckoutKit object has been instantiated to retrieve it
    
    @throws CheckoutError if an error occurs, the public key is invalid or the CheckoutKit instance has not been instantiated before
    
    @returns null if getInstance has not been called before specifying all the parameters or the CheckoutKit object

    */

    open class func getInstance() throws -> CheckoutKit? {
        if (ck == nil) {
            throw CheckoutError.noPK
        }
        return ck
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    @param pk String containing the merchant's public key
    
    @param debug boolean, if the debug mode is activated or not, default is true
    
    @param logger Log instance for logging purposes if debug mode is activated
    
    @throws CheckoutError if an error occurs or the public key is invalid
    
    */
    
    open class func getInstance(_ pk: String, debug: Bool, logger: Log) throws -> CheckoutKit? {
        if (ck == nil) {
            ck = try CheckoutKit(pk: pk, env: Environment.LIVE, debug: debug, logger: logger)
        }
        return ck
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    @param pk String containing the merchant's public key
    
    @param env Environment object containing the information of the merchant's environment, default is SANDBOX
    
    @param logger Log instance for logging purposes if debug mode is activated
    
    @throws CheckoutError if an error occurs or the public key is invalid
    
    */
    
    open class func getInstance(_ pk: String, env: Environment, logger: Log) throws -> CheckoutKit? {
        if (ck == nil) {
            ck = try CheckoutKit(pk: pk, env: env, debug: true, logger: logger)
        }
        return ck
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    @param pk String containing the merchant's public key
    
    @param env Environment object containing the information of the merchant's environment, default is SANDBOX
    
    @param debug boolean, if the debug mode is activated or not, default is true
    
    @throws CheckoutError if an error occurs or the public key is invalid
    
    */
    
    open class func getInstance(_ pk: String, env: Environment, debug: Bool) throws -> CheckoutKit? {
        if (ck == nil) {
            ck = try CheckoutKit(pk: pk, env: env, debug: debug, logger: Log.getLog())
        }
        return ck
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    @param pk String containing the merchant's public key
    
    @param env Environment object containing the information of the merchant's environment, default is SANDBOX
    
    @throws CheckoutError if an error occurs or the public key is invalid
    
    */
    
    open class func getInstance(_ pk: String, env: Environment) throws -> CheckoutKit? {
        if (ck == nil) {
            ck = try CheckoutKit(pk: pk, env: env, debug: true, logger: Log.getLog())
        }
        return ck
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    @param pk String containing the merchant's public key
    
    @param logger Log instance for logging purposes if debug mode is activated
    
    @throws CheckoutError if an error occurs or the public key is invalid
    
    */
    
    open class func getInstance(_ pk: String, logger: Log) throws -> CheckoutKit? {
        if (ck == nil) {
            ck = try CheckoutKit(pk: pk, env: Environment.LIVE, debug: true, logger: logger)
        }
        return ck
    }
    
    /**
    
    Function used for the Singleton Pattern, returns a unique CheckoutKit instance
    
    @param pk String containing the merchant's public key
    
    @param debug boolean, if the debug mode is activated or not, default is true
    
    @throws CheckoutError if an error occurs or the public key is invalid
    
    */
    
    open class func getInstance(_ pk: String, debug: Bool) throws -> CheckoutKit? {
        if (ck == nil) {
            ck = try CheckoutKit(pk: pk, env: Environment.LIVE, debug: debug, logger: Log.getLog())
        }
        return ck
    }
    
    /*
    
    Private function used for generating the correct url for REST calls
    
    @param function RESTFunction instance containing the details of the REST fonction to be called
    
    */
    
    fileprivate func getUrl(_ function: RESTFunction) -> String {
        return "\(self.env.rawValue)\(function.rawValue)"
    }
    
    /**
    
    Function that calls getCardProviders via REST on the server specified in Environment
    
    @param completion Handler having a instance of Response<CardProviderResponse> as a parameter
    
    @return CardProvider array containing the Checkout card providers
    
    */
    
    open func getCardProviders(_ completion: @escaping (Response<CardProviderResponse>) -> Void) {
        if(logging){
            logger.info("**GetCardProviders called**   \(pk)")
        }
        HTTPRequest.getRequest(getUrl(RESTFunction.GETCARDPROVIDERS), pk: self.pk, debug: self.logging, logger: self.logger, completion:{ (resp: Response<CardProviderResponse>) -> Void in
            completion(resp)
        })
    }
    
    /**
    
    Function that calls createCardToken via REST on the server specified in Environment
    
    @param card Card object containing the informations to be tokenized
    
    @param completion Handler having a instance of Response<CardTokenResponse> as a parameter
    
    @return CardToken object containing all the information received by the server

    */
    
    open func createCardToken(_ card: Card, completion: @escaping (Response<CardTokenResponse>) -> Void) {
        if(logging){
            logger.info("**CreateCardToken called**   \(pk)")
        }
        var data: String = ""
        if JSONSerialization.isValidJSONObject(card.getJson()) {
            let c = try? JSONSerialization.data(withJSONObject: card.getJson(), options: [])
            data = NSString(data: c!, encoding:String.Encoding.utf8.rawValue)! as String
        }
        HTTPRequest.postRequest(getUrl(RESTFunction.CREATECARDTOKEN), payload: data, pk: self.pk, debug: self.logging, logger: self.logger, completion:{ (resp: Response<CardTokenResponse>) -> Void in
            completion(resp)
        })
        
    }
    
    open class func destroy() {
        ck = nil
    }
}

/*

Enumeration containing the different environments for generating the tokens, it contains the URL corresponding to the environment

*/

public enum Environment: String {
    case LIVE = "https://api2.checkout.com/v2/"
    case SANDBOX = "https://sandbox.checkout.com/api2/v2/"
}
