//
//  MDVWeightHeightTB.swift
//  MdVisionVitals
//
//  Created by Muhammad Zia Ur Rehman on 5/29/18.
//  Copyright © 2018 MDVisions. All rights reserved.
//

import UIKit

class QHomeVCTabBar: UIViewController, UITabBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var container: ContainerViewController!
    @IBOutlet weak var tabbar: UITabBar!
    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sideMenu: UIViewX!
    @IBOutlet weak var btnLogIn: UIButton!

   let kVersion = "CFBundleShortVersionString"
    
    var selectedItem = 1
    var tabTitle = ""
    var sideMenuArray = [(String,String)]()
    var index = 0
    var dismissBtn : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.black
        button.alpha = 0
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblAppVersion.text = "Application version : \(getAppVersionNumber())"

        //here's the code that creates no border, but has a shadow:
        
        tabbar.layer.shadowColor = UIColor.lightGray.cgColor
        tabbar.layer.shadowOpacity = 0.2
        tabbar.layer.shadowOffset = CGSize.zero
        tabbar.layer.shadowRadius = 5
        self.tabbar.layer.borderColor = UIColor.clear.cgColor
        self.tabbar.layer.borderWidth = 0
        self.tabbar.clipsToBounds = false
        self.tabbar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
  
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.callHomePage), name: NSNotification.Name(rawValue: "callHomePage"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToCart), name: NSNotification.Name(rawValue: "goToCart"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.callSpecialViewController), name: NSNotification.Name(rawValue: "callSpecialViewController"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideNavigationBar(_:)), name: NSNotification.Name(rawValue: "hideNavigationBar"), object: nil)
////        guard let add = APIManager.sharedInstance.getCustomer()?.address_id else {return}
//        if (APIManager.sharedInstance.getCustomer()?.customer_id) != nil {
//            btnLogIn.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Logout", comment: ""), for: .normal)
//        }else {
//            btnLogIn.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "LOGIN", comment: ""), for: .normal)
//        }
        

        
    sideMenuArray = [(LocalizationSystem.shared.localizedStringForKey(key: "Home", comment: ""),"0"),
                     (LocalizationSystem.shared.localizedStringForKey(key: "Offers", comment: ""),"1"),
                     (LocalizationSystem.shared.localizedStringForKey(key: "OrderHistory", comment: ""),"3"),
                     (LocalizationSystem.shared.localizedStringForKey(key: "MyCart", comment: ""),"2"),
                     (LocalizationSystem.shared.localizedStringForKey(key: "MyLists", comment: ""),"4"),
                     (LocalizationSystem.shared.localizedStringForKey(key: "StoreCredit", comment: ""),"5"),
                     (LocalizationSystem.shared.localizedStringForKey(key: "Share", comment: ""),"9"),
                     (LocalizationSystem.shared.localizedStringForKey(key: "Language", comment: ""),"7"),
                     (LocalizationSystem.shared.localizedStringForKey(key: "ContactUs", comment: ""),"5"),
                     ("Live Chat","chat")]
        
        tabbar.selectedItem = tabbar.items?[self.selectedItem]
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveToNextWH), name: NSNotification.Name(rawValue: "moveToNextWH"), object: nil)
        
        
        
        sideMenu.frame = CGRect(x: -sideMenu.frame.width, y: 0, width: view.frame.width / 1.3, height: view.frame.height)
        dismissBtn.addTarget(self, action: #selector(closeSideBar), for: .touchUpInside)
        // Do any additional setup after loading the view.
        
        self.title = " "

    }
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
        
        
        if let fname = APIManager.sharedInstance.getCustomer()?.firstname, let lname = APIManager.sharedInstance.getCustomer()?.lastname {
            lblName.text = fname + " " + lname
        }else {
            lblName.text = "Customer Name"
        }
        
        if let email = APIManager.sharedInstance.getCustomer()?.email  {
            lblAddress.text = email
        }else {
            lblAddress.text = "emailAddress@example.com"
        }
        
        
        self.tabbar.delegate = self
        self.navigationController?.navigationBar.isHidden = true
        if (APIManager.sharedInstance.getCustomer()?.customer_id) != nil  {
            btnLogIn.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Logout", comment: ""), for: .normal)
        }else {
            btnLogIn.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "LOGIN", comment: ""), for: .normal)
        }
        switch self.selectedItem {
        case 0:
            container.firstLinkedSubView = "home"
            tabbar.selectedItem = tabbar.items?[self.selectedItem]
//            performSeg(text: "", viewcontrollerId: "home")
//            performSeg(text: "", viewcontrollerId: "home")
            break
        case 1:
            container.firstLinkedSubView = "home"
            tabbar.selectedItem = tabbar.items?[self.selectedItem]
//            performSeg(text: "", viewcontrollerId: "home")
            break
        case 2:
            container.firstLinkedSubView = "specialOffers"
            tabbar.selectedItem = tabbar.items?[self.selectedItem]
            break
        case 3:
            container.firstLinkedSubView = "account"
            tabbar.selectedItem = tabbar.items?[self.selectedItem]
            break
        case 4:
            container.firstLinkedSubView = "wishlist"
            tabbar.selectedItem = tabbar.items?[self.selectedItem]
            break
        default:
            print("nothing")
            break
        }
    }
    override func viewDidAppear(_ animated: Bool) {

    }
    
    override func viewDidLayoutSubviews() {
 
    }
    
    
    //Get app version number
    func getAppVersionNumber() -> Double {
        let Dict = Bundle.main.infoDictionary!
        let version = Dict[kVersion] as! String
        return Double(version)!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 {
            window.addSubview(dismissBtn)
            dismissBtn.frame = window.bounds
            openSideMenu()
        }else if item.tag == 1 {

                self.selectedItem = 1
                performSeg(text: "", viewcontrollerId: "home")
//            }
        }else if item.tag == 2 {

                self.selectedItem = 2
                performSeg(text: "", viewcontrollerId: "specialOffers")
        }else if item.tag == 3 {
            self.selectedItem = 3
            performSeg(text: "", viewcontrollerId: "account")
        }
        else if item.tag == 4{
            self.selectedItem = 4
            performSeg(text: "", viewcontrollerId: "wishlist")
        }
    }
    @objc func moveToNextWH(_ notification: NSNotification)  {
        if self.tabTitle == "list" {
            performSeg(text: "", viewcontrollerId: "home")
            tabbar.selectedItem = tabbar.items?[1]
            self.selectedItem = 1
        }else {
            performSeg(text: "", viewcontrollerId: "trend")
            tabbar.selectedItem = tabbar.items?[2]
            self.selectedItem = 2
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //MARK:- BTN ACTIONS
    
    @IBAction func btnSideMenu(_ sender: UIButton) {
        window.addSubview(dismissBtn)
        dismissBtn.frame = window.bounds
        openSideMenu()
    }
    
    
    
    @IBAction func btnEditProfile(_ sender: UIButton) {
        closeSideBar()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QUpdateProfileVC") as? QUpdateProfileVC
        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func btnLogIn(_ sender: UIButton) {
        closeSideBar()

        if (APIManager.sharedInstance.getCustomer()?.customer_id) != nil {
            btnLogIn.setTitle("LOG OUT", for: .normal)
            APIManager.sharedInstance.setCustomer(in: Customer())
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QTabbarNavigationController") as! QTabbarNavigationController
            window.rootViewController = vc
            window.makeKeyAndVisible()
            
        } else {
            btnLogIn.setTitle("LOG IN", for: .normal)
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QSignInVC")
            window.rootViewController = vc
            window.makeKeyAndVisible()
        }
    }
    
    
    func openSideMenu(){
        window.addSubview(self.sideMenu)
        
        //        self.dismissbutton.isHidden = false
        self.sideMenu.bringSubviewToFront(self.view)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.selectRow(at: IndexPath(row: self.index, section: 0), animated: true, scrollPosition: .none)
        UIView.animate(withDuration: 0.3) {
            self.dismissBtn.alpha = 0.5
            self.sideMenu.frame.origin.x = 0
            self.view.frame.origin.x = self.sideMenu.frame.width
            self.navigationController?.navigationBar.frame.origin.x = self.sideMenu.frame.width
            //            self.sta.frame.origin.x = self.sideMenu.frame.width
        }
        
    }
    
    @objc func closeSideBar() {
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenu.frame.origin.x = -self.sideMenu.frame.width
            self.view.frame.origin.x = 0
            self.navigationController?.navigationBar.frame.origin.x = 0
            self.dismissBtn.alpha = 0
            //            self.mainView.frame.origin.x = 0
            //            self.sta.frame.origin.x = 0
        }) { (true) in
            //            self.dismissbutton.isHidden = true
            self.sideMenu.removeFromSuperview()
            self.dismissBtn.removeFromSuperview()
        }
        tabbar.selectedItem = tabbar.items?[self.selectedItem]
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sideMenuArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideBar", for: indexPath) as! MDVSideBarCell
        //
        //        if indexPath.row == 0 {
        //            cell.line.isHidden = false
        //            //            cell.line2.isHidden = false
        //        }
        //
        cell.lblTitle.text = sideMenuArray[indexPath.row].0
        cell.imgSideMenu.image = UIImage(named: "\(sideMenuArray[indexPath.row].1)")

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return window.frame.height / 16
    }
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
 
//        closeSideBar()
        self.index = indexPath.row
        closeSideBar()
        if indexPath.row == 0 {

            self.selectedItem = 1
            performSeg(text: "", viewcontrollerId: "home")
            tabbar.selectedItem = tabbar.items?[1]
            
        } else if indexPath.row == 1 {
//
//            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QSpecialOffersVC") as? QSpecialOffersVC
//            self.navigationController?.pushViewController(vc!, animated: true)
//            self.navigationController?.navigationBar.isHidden = false
            self.selectedItem = 2
            performSeg(text: "", viewcontrollerId: "specialOffers")
            tabbar.selectedItem = tabbar.items?[2]
            
        } else if indexPath.row == 2 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QOrderHistoryVC") as? QOrderHistoryVC
            self.navigationController?.pushViewController(vc!, animated: true)
            self.navigationController?.navigationBar.isHidden = false
        } else if indexPath.row == 3 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QCartVc") as? QCartVc
            self.navigationController?.pushViewController(vc!, animated: true)
            self.navigationController?.navigationBar.isHidden = false
        } else if indexPath.row == 4 {
            
            self.selectedItem = 4
            performSeg(text: "", viewcontrollerId: "wishlist")
            tabbar.selectedItem = tabbar.items?[4]
            
        } else if indexPath.row == 5 {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QStoreCreditVC") as? QStoreCreditVC
            self.navigationController?.pushViewController(vc!, animated: true)
            self.navigationController?.navigationBar.isHidden = false
            
        } else if indexPath.row == 6 {
            
//            let imgUrl = "https://www.qareeb.com"
//            let items = [URL(string: imgUrl)!]
//            let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
//            present(ac, animated: true)
            openShareDilog()
            
            
            
        } else if indexPath.row == 7 {
            var lang = APIManager.sharedInstance.getLanguage()
            if APIManager.sharedInstance.getLanguage()?.id == "1" {
                lang?.code = "ar"
                lang?.id = "3"
            } else {
                lang?.code = "en"
                lang?.id = "1"
            }
            
            APIManager.sharedInstance.setLanguage(in: lang!)
            LocalizationSystem.shared.setLanguage(languageCode: APIManager.sharedInstance.getLanguage()!.code)
//            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            let vc = storyboard?.instantiateViewController(withIdentifier: "QTabbarNavigationController") as! QTabbarNavigationController
            window.rootViewController = vc
            window.makeKeyAndVisible()
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
//            self.present(vc, animated: true, completion: nil)
            
            
            
        } else if indexPath.row == 8 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QContactUsVC") as? UIViewController
            self.navigationController?.pushViewController(vc!, animated: true)
            self.navigationController?.navigationBar.isHidden = false
//            performSeg(text: "Support", viewcontrollerId: "support")
        } else if indexPath.row == 9 {
//            LiveChat.clearSession()
//            LiveChat.presentChat()
            openWhatsapp()
        }
        
    }
    
    
    //Open whats application from app
    func openWhatsapp(){
        let urlWhats = "whatsapp://send?phone=+966550053653"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed){
            if let whatsappURL = URL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL){
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(whatsappURL, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(whatsappURL)
                    }
                }
                else {
                    APIManager.sharedInstance.customPOP(isError: true, message: "Install Whatsapp")
                }
            }
        }
    }
    //Go to Special view controller for view more
    @objc func callSpecialViewController(_ notification: NSNotification)  {
        self.selectedItem = 2
        performSeg(text: "", viewcontrollerId: "specialOffers")
        tabbar.selectedItem = tabbar.items?[2]
    }
    //Calling Home view controller
    @objc func callHomePage(_ notification: NSNotification)  {
        self.selectedItem = 1
        performSeg(text: "", viewcontrollerId: "home")
    }
    //Go to cart view controller
    @objc func goToCart(_ notification: NSNotification)  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QCartVc") as? QCartVc
        self.navigationController?.pushViewController(vc!, animated: true)
        self.navigationController?.navigationBar.isHidden = false
    }
//
    //Go to cart view controller
    @objc func hideNavigationBar(_ notification: NSNotification)  {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func openShareDilog() {
        let text = "https://www.qareeb.com"

        // set up activity view controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [.airDrop]

        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2, width: 0, height: 0)
            popoverController.sourceView = self.view
            popoverController.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    
    func performSeg(text: String, viewcontrollerId: String) {
        title = text
        container!.segueIdentifierReceivedFromParent("\(viewcontrollerId)")
        UIView.animate(withDuration: 0.0, animations: {
            
        }) { (true) in
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "container"{
            container = segue.destination as! ContainerViewController
        }
    }
    
}
