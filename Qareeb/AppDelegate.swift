//
//  AppDelegate.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 15/02/2019.
//  Copyright © 2019 MDVision. All rights reserved.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

import CoreLocation
import GoogleMaps
import GoogleSignIn
import GooglePlaces
import FBSDKLoginKit
import FBSDKCoreKit

import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import OneSignal
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate , UNUserNotificationCenterDelegate, MessagingDelegate  {

    var window: UIWindow?

  
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        UIApplication.shared.statusBarView?.backgroundColor = #colorLiteral(red: 0.4138659835, green: 0.2565160394, blue: 0.5640606284, alpha: 1)
        IQKeyboardManager.shared.enable = true
        UIApplication.shared.statusBarStyle = .lightContent
  
        
        Fabric.with([Crashlytics.self])
//        "${PODS_ROOT}/Fabric/run" 3fd8e7aabe0fec9525887f2d456b0eeabb5dd4e0 9549c494f898059ca46148ad28f0a5df6e503f133a97379cefbf0548ee9db59e
        self.logUser()
        
//        //MARK: - live chat integreation
//        LiveChat.groupId = "0"
//        LiveChat.licenseId = "10834042"
////        LiveChat.name = APIManager.sharedInstance.getCustomer()?.firstname // User name and email can be provided if known
////        LiveChat.email = APIManager.sharedInstance.getCustomer()?.email
        

        
        // Initialize sign-in
        GIDSignIn.sharedInstance().clientID = "538476992101-2kv5u5kqgipehjemvqqvp84697aaj9ab.apps.googleusercontent.com"
//        GIDSignIn.sharedInstance().delegate = self
        
        GMSServices.provideAPIKey("AIzaSyAyAhBLszv_6xK472hyxnSfSFl8IDtylmE")
        GMSPlacesClient.provideAPIKey("AIzaSyAyAhBLszv_6xK472hyxnSfSFl8IDtylmE")
        
        _ =  Location.getLocation(withAccuracy:.any, frequency: .significant, onSuccess: { [weak self] location in
            //            print("loc \(location.coordinate.longitude)\(location.coordinate.latitude)")
            DEVICE_LAT = location.coordinate.latitude
            DEVICE_LONG = location.coordinate.longitude
            
            CURRENT_DEVICE_LAT = location.coordinate.latitude
            CURRENT_DEVICE_LONG = location.coordinate.longitude
        
            
            let geoCoder = CLGeocoder()

            let location = CLLocation(latitude: 21.486618, longitude: 39.193288)
            
            geoCoder.reverseGeocodeLocation(location, completionHandler: { [weak self] placemarks, error in
                guard let addressDict = placemarks?[0].addressDictionary else {
                    return
                }
                
                guard let city = placemarks?[0].locality else {
                    print("city not found")
                    return
                }
                print(city)
                // Print each key-value pair in a new row
                addressDict.forEach { print($0) }
                
                // Print fully formatted address
                if let formattedAddress = addressDict["FormattedAddressLines"] as? [String] {
                    //                    print(formattedAddress.joined(separator: ", "))
//                    DEVICE_ADDRESS = formattedAddress.joined(separator: ", ")
                    //                    self?.address = formattedAddress.joined(separator: ", ")
                    
                    
                    
                }
            })
            
            }, onError: { (last, error) in
                print("Something bad has occurred \(error)")
        })

        //MARK:- CHECKING IS USER VISITING  FIRST TIME
        
        if APIManager.sharedInstance.getIsFirstTime()?.id == "0" {
            let storyboard = UIStoryboard(name: "WalkGate", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "gate") as! WalkGate
            window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            var isfirst = IsFirstTime()
            isfirst.id = "1"
            APIManager.sharedInstance.setIsFirstTime(in: isfirst)
        }

        
        
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        registerForPushNotifications()

        
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        LocalizationSystem.shared.setLanguage(languageCode: APIManager.sharedInstance.getLanguage()!.code)
        
//
//

        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]

        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "c7e4b4b0-091a-42bd-a879-02b103bc2178",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)

        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;

        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })

//        FirebaseApp.configure()
//
//        if #available(iOS 10.0, *) {
//            // For iOS 10 display notification (sent via APNS)
//            UNUserNotificationCenter.current().delegate = self
//
//            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//            UNUserNotificationCenter.current().requestAuthorization(
//                options: authOptions,
//                completionHandler: {_, _ in })
//        } else {
//            let settings: UIUserNotificationSettings =
//                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
//            application.registerUserNotificationSettings(settings)
//        }
//
//        application.registerForRemoteNotifications()
//
        //Getting Country list for service
        APIManager.sharedInstance.countryList = APIManager.sharedInstance.countryNamesByCode()
//
        
        return true
    }
    
    func defaultStore()  {
        
//        var savedStore = APIManager.sharedInstance.getStore()
//               savedStore?.seller_id           = "33"
//               savedStore?.city_id             = storeData?.city_id
//               savedStore?.firstname           = "Jumlah"
//               savedStore?.lastname            = "جملة"
//               savedStore?.email               = "info@jumlah.com"
//               savedStore?.minimum_order       = "200"
//               savedStore?.delivery_charges    = "0.00"
//               savedStore?.image               = storeData?.image
//               savedStore?.banner              = storeData?.banner
//               savedStore?.time_content        = storeData?.time_content
//               savedStore?.time                = storeData?.time
//               savedStore?.store_status        = storeData?.store_status
//               savedStore?.rating              = storeData?.rating
//               savedStore?.latitude            = storeData?.latitude
//               savedStore?.longitude           = storeData?.longitude
//
//               APIManager.sharedInstance.setStore(in: savedStore  ?? Store())
//        
        
//        struct Store: Codable {
//
//            var seller_id      = "33"
//            var firstname      = "Jumlah"
//            var lastname       = "جملة"
//            var email           = "info@jumlah.com"
//            var minimum_order  = "200"
//            var delivery_charges = "0.00"
//            var image            = "https://www.qareeb.com/image/cache/Jumlah/Jumlah-Logo-720x406.png"
//            var banner          = "https://www.qareeb.com/image/cache/Jumlah/Jumlah_banner-1498x286.jpg"
//            var time_content    = "Next Delivery Tomorrow 12:00 pm - 04:40 pm"
//            var time            = "12:00 pm - 04:40 pm"
//            var store_status    = "open"
//            var rating          = "0.0"
//            var longitude       : String?
//            var latitude        : String?
//            var city_id         = "25"
//
//        }
//
//        struct CityAndArea: Codable {
//            var cityName    : String?
//            var cityId      : String? = "25"
//            var areaName    : String?
//            var areaId      : String?  = "164"
//        }
    }
    
    func logUser() {
        // TODO: Use the current user's information
        // You can call any combination of these three methods
        Crashlytics.sharedInstance().setUserEmail("user@fabric.io")
        Crashlytics.sharedInstance().setUserIdentifier("12345")
        Crashlytics.sharedInstance().setUserName("Test User")
        
    }
    
    func getNotificationSettings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                guard settings.authorizationStatus == .authorized else { return }
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.registerForRemoteNotifications()
                })
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
                (granted, error) in
                guard granted else { return }
                self.getNotificationSettings()
            }
        } else {
            let settings = UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    
    private func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        let handle = FBSDKApplicationDelegate.sharedInstance().application(
            app,
            open: url as URL,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
        
        
        return handle || GIDSignIn.sharedInstance().handle(url as URL?,
                                                         sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                         annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }
    
    
    //MARK: - PUSH NOTIFICATIOS DELEGATES
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print(fcmToken)
        var deviceToken = APIManager.sharedInstance.getIsFirstTime()
        deviceToken?.token = fcmToken
        APIManager.sharedInstance.setIsFirstTime(in: deviceToken!)
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//        let token = deviceToken.map { String(format: "%02.2hhx", $0)}.joined()
//        var deviceToken = APIManager.sharedInstance.getIsFirstTime()
//        deviceToken?.token = token
//        APIManager.sharedInstance.setIsFirstTime(in: deviceToken!)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        debugPrint(response.notification.date)
    }

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert, .sound])
    }    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Qareeb")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}



