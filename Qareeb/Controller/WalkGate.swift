//
//  WalkGate.swift
//  American One
//
//  Created by M Zia Ur Rehman Ch. on 24/01/2018.
//  Copyright © 2018 M Zia Ur Rehman Ch. All rights reserved.
//

import UIKit
import DropDown

class WalkGate: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pagecontrol: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let dropDown = DropDown()
    
    let data =  [(LocalizationSystem.shared.localizedStringForKey(key: "SET_LOCATION", comment: "").capitalized, LocalizationSystem.shared.localizedStringForKey(key: "SET_LOCATION_DESCRIPTION", comment: "") ,"location_1"),
                 (LocalizationSystem.shared.localizedStringForKey(key: "SELECT_STORE", comment: "").capitalized, LocalizationSystem.shared.localizedStringForKey(key: "PLACE_ORDER_DESCRIPTION", comment: "") ,"selectStore_1"),
                 (LocalizationSystem.shared.localizedStringForKey(key: "PLACE_YOUR_ORDER", comment: "").capitalized, LocalizationSystem.shared.localizedStringForKey(key: "PLACE_ORDER_DESCRIPTION", comment: "") ,"delivered"),
                 (LocalizationSystem.shared.localizedStringForKey(key: "GET_DELIVERY", comment: "").capitalized, LocalizationSystem.shared.localizedStringForKey(key: "GET_DELIVERY_DESCRIPTION", comment: "") ,"shoppingBag")
    ]
    

    
    
    let languages = ["English","العربية"]
    
    var nextIndex: IndexPath!
    var previousIndex: IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.lblPaymentMethod.text = item
            print("Selected item: \(item) at index: \(index)")
            var lang = Languages()

            if index == 0 {
                lang.id = "1"
                lang.code = "en"
            }  else if index == 1 {
                lang.id = "3"
                lang.code = "ar"
            }
            APIManager.sharedInstance.setLanguage(in: lang)
            LocalizationSystem.shared.setLanguage(languageCode: APIManager.sharedInstance.getLanguage()!.code)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UIView.appearance().semanticContentAttribute = .forceLeftToRight

            let storyboard = UIStoryboard(name: "WalkGate", bundle: nil)
                       let vc = storyboard.instantiateViewController(withIdentifier: "gate") as! WalkGate
                       window.rootViewController = vc
                       window.makeKeyAndVisible()
        }
        setUpUI()

        // Do any additional setup after loading the view.
    }
    
    func setUpUI()  {
          
          nextButton.setTitle(Language.value(key: "NEXT").uppercased(), for: .normal)
          backButton.setTitle(Language.value(key: "SKIP").uppercased(), for: .normal)
          if APIManager.sharedInstance.getLanguage()?.id == "1" {// Language is English
              self.nextButton.titleLabel?.font = UIFont(name: FONT.enSemiBold.rawValue, size: (self.nextButton.titleLabel?.font.pointSize)!)
              self.backButton.titleLabel?.font = UIFont(name: FONT.enSemiBold.rawValue, size: (self.backButton.titleLabel?.font.pointSize)!)
          } else {
              self.nextButton.titleLabel?.font = UIFont(name: FONT.arBold.rawValue, size: (self.nextButton.titleLabel?.font.pointSize)!)
              self.backButton.titleLabel?.font = UIFont(name: FONT.arBold.rawValue, size: (self.backButton.titleLabel?.font.pointSize)!)
          }
      }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! GateWayCell
        cell.heading.text = data[indexPath.item].0
        cell.subHeading.text = data[indexPath.item].1
//        cell.bImage.image = UIImage(named: "onBoarding")
        cell.logoImage.image = UIImage(named: "\(data[indexPath.item].2)")
        
        cell.closeHandler = {()-> Void in
//            self.notifime()
        }
        cell.notnowHandler = {()-> Void in
           self.jumpToHomeScreen()
        }
        cell.language = {(sender)-> Void in
            self.setLanguage(sender: sender)
        }
        
        if indexPath.item == 0 {
            cell.btnLanguage.isHidden = false
        }else {
            cell.btnLanguage.isHidden = true
        }
        
        if indexPath.item == (data.count - 1) {
            cell.enableNotification.isHidden = false
            cell.notNow.isHidden = false
            
        }else{
            cell.enableNotification.isHidden = true
            cell.notNow.isHidden = true
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.item)
        pagecontrol.currentPage = indexPath.item
//        if indexPath.item == 0 {
////            backButton.isHidden = true
//
//        }else {
//            backButton.isHidden = false
//        }
        if indexPath.item == (data.count - 1) {
            nextButton.isHidden = true
            backButton.isHidden = true
            pagecontrol.isHidden = true
        }else {
            nextButton.isHidden     = false
            pagecontrol.isHidden    = false
            backButton.isHidden     = false

        }
       
        if indexPath.item < data.count {
            self.nextIndex = IndexPath(item: indexPath.item + 1, section: 0)
        }
        
        if indexPath.item > 0 {
           self.previousIndex = IndexPath(item: indexPath.item - 1, section: 0)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @IBAction func nextBtn(_ sender: Any) {
        self.collectionView.scrollToItem(at: self.nextIndex, at: .left, animated: true)
    }
    @IBAction func previousBtn(_ sender: Any) {
//        self.collectionView.scrollToItem(at: self.previousIndex, at: .right, animated: true)
        jumpToHomeScreen()
        
    }
    
    
//    func notifime()  {
////      UIApplication.openAppSettings()
//        let notificationType = UIApplication.shared.currentUserNotificationSettings?.types
//        if notificationType?.rawValue == 0 {
//           UIApplication.openAppSettings()
//        } else {
//            APIManager.sharedInstance.customPOP(message: "Notifications are Enable")
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "mainView") as UIViewController
//            vc.modalTransitionStyle = .crossDissolve
//            self.present(vc, animated: true, completion: nil)
//        }
//    }
    
    func setLanguage(sender: ButtonX)  {
        dropDown.anchorView = sender
        self.dropDown.bottomOffset = CGPoint(x: 0, y:((self.dropDown.anchorView?.plainView.bounds.height)!) + CGFloat(3.0))
        self.dropDown.dataSource = languages
        self.dropDown.show()
    }
    
    func jumpToHomeScreen() {
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "QTabbarNavigationController") as! QTabbarNavigationController
        vc.modalTransitionStyle = .crossDissolve
        window.rootViewController = vc
        window.makeKeyAndVisible()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
extension UIApplication {
    class func openAppSettings() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: {enabled in
            print("yahoo")
        })
}
}

















