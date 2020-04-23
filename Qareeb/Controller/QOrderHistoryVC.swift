
//
//  QOrderHistoryVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 26/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SVProgressHUD

class QOrderHistoryVC: UIViewController {

    @IBOutlet weak var noDataView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblNodataAvailable: UILabel!
    @IBOutlet weak var lblSubtitleNoData: UILabel!
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var orders: [Order]?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        localizeStrings()
        collectionView.register(UINib(nibName: "QOrderCell", bundle: nil), forCellWithReuseIdentifier: "QOrderCell")
        
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: screenWidth -  20 , height: self.view.frame.width / 1.7)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
       
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
         guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: "")); return }
               getOrdersInfo(customerId: customerId)
    }
        
    //Localization configrations
    func localizeStrings() {
        title = LocalizationSystem.shared.localizedStringForKey(key: "orders_history", comment: "")
        lblNodataAvailable.text = LocalizationSystem.shared.localizedStringForKey(key: "Data_not_found", comment: "")
        lblSubtitleNoData.text = LocalizationSystem.shared.localizedStringForKey(key: "there_is_no_data_to_show_you", comment: "")
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension QOrderHistoryVC:  UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.orders?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QOrderCell", for: indexPath) as! QOrderCell
        let order = self.orders?[indexPath.item]
        cell.viewDetails = {() -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QOrderInfoVC") as? QOrderInfoVC
            vc?.orderHistory = order
            self.navigationController?.pushViewController(vc!, animated: true)
        }
        
        cell.payOrder = {() -> Void in
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "QCheckOutPaymentVC") as! QCheckOutPaymentVC
            vc.amount = order?.total
            vc.orderIds = order?.order_id
            vc.orderHistory = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
//        if let statusId = order?.order_status_id {
//          cell.status(statusId)
//        }
        
//
//        if  order?.order_status_id == "1"  {
//            cell.isAction([(cell.imgPlaced, cell.lblPlaced)], [(cell.imgAccepted,cell.lblAccepted),(cell.imgShopping,cell.lblShopping),(cell.imgOnTheWay,cell.lblOnTheWay),(cell.imgDelivered,cell.lblDelivered)])
//        } else if order?.order_status_id == "18" {
//            cell.isAction([(cell.imgPlaced, cell.lblPlaced),(cell.imgAccepted,cell.lblAccepted)], [(cell.imgShopping,cell.lblShopping),(cell.imgOnTheWay,cell.lblOnTheWay),(cell.imgDelivered,cell.lblDelivered)])
//        } else if  order?.order_status_id == "3"  {
//            cell.isAction([(cell.imgPlaced, cell.lblPlaced)], [(cell.imgAccepted,cell.lblAccepted),(cell.imgShopping,cell.lblShopping),(cell.imgOnTheWay,cell.lblOnTheWay),(cell.imgDelivered,cell.lblDelivered)])
//        } else {
//            cell.isAction([(cell.imgPlaced, cell.lblPlaced),(cell.imgAccepted,cell.lblAccepted),(cell.imgShopping,cell.lblShopping),(cell.imgOnTheWay,cell.lblOnTheWay),(cell.imgDelivered,cell.lblDelivered)], [])
//        }
//
        
        cell.lblId.text  = order?.order_id
        cell.lblDate.text = order?.date_added
        cell.lblReceived.text = ""
        cell.lblTotal.text = order?.total
        
        if order?.order_status_id == "27" {
            cell.showPayButton(isShowing: true)
        } else {
            cell.showPayButton(isShowing: false)
        }
        
        switch order?.order_status_id {
             case "1","27","2":
             cell.imgPlaced.image    = #imageLiteral(resourceName: "checkMarkActive")
             cell.imgAccepted.image  = #imageLiteral(resourceName: "checkMarkNotActive")
             cell.imgOnTheWay.image  = #imageLiteral(resourceName: "checkMarkNotActive")
             cell.imgShopping.image  = #imageLiteral(resourceName: "checkMarkNotActive")
             cell.imgDelivered.image = #imageLiteral(resourceName: "checkMarkNotActive")
             
             cell.lblPlaced.textColor = UIColor(named: "boringGreen")
             cell.lblAccepted.textColor = UIColor(named: "lightBlueGrey")
             cell.lblShopping.textColor = UIColor(named: "lightBlueGrey")
             cell.lblOnTheWay.textColor = UIColor(named: "lightBlueGrey")
             cell.lblDelivered.textColor = UIColor(named: "lightBlueGrey")
            case "18":
            cell.imgPlaced.image    = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgAccepted.image  = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgOnTheWay.image  = #imageLiteral(resourceName: "checkMarkNotActive")
            cell.imgShopping.image  = #imageLiteral(resourceName: "checkMarkNotActive")
            cell.imgDelivered.image = #imageLiteral(resourceName: "checkMarkNotActive")
            
            cell.lblPlaced.textColor = UIColor(named: "boringGreen")
            cell.lblAccepted.textColor = UIColor(named: "boringGreen")
            cell.lblShopping.textColor = UIColor(named: "lightBlueGrey")
            cell.lblOnTheWay.textColor = UIColor(named: "lightBlueGrey")
            cell.lblDelivered.textColor = UIColor(named: "lightBlueGrey")
            case "3":
            cell.imgPlaced.image    = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgAccepted.image  = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgOnTheWay.image  = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgShopping.image  = #imageLiteral(resourceName: "checkMarkNotActive")
            cell.imgDelivered.image = #imageLiteral(resourceName: "checkMarkNotActive")
            
            cell.lblPlaced.textColor = UIColor(named: "boringGreen")
            cell.lblAccepted.textColor = UIColor(named: "boringGreen")
            cell.lblShopping.textColor = UIColor(named: "boringGreen")
            cell.lblOnTheWay.textColor = UIColor(named: "lightBlueGrey")
            cell.lblDelivered.textColor = UIColor(named: "lightBlueGrey")
            case "17","20":
            cell.imgPlaced.image    = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgAccepted.image  = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgOnTheWay.image  = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgShopping.image  = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgDelivered.image = #imageLiteral(resourceName: "checkMarkNotActive")
            
            cell.lblPlaced.textColor = UIColor(named: "boringGreen")
            cell.lblAccepted.textColor = UIColor(named: "boringGreen")
            cell.lblShopping.textColor = UIColor(named: "boringGreen")
            cell.lblOnTheWay.textColor = UIColor(named: "boringGreen")
            cell.lblDelivered.textColor = UIColor(named: "lightBlueGrey")
        default:
            cell.imgPlaced.image    = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgAccepted.image  = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgOnTheWay.image  = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgShopping.image  = #imageLiteral(resourceName: "checkMarkActive")
            cell.imgDelivered.image = #imageLiteral(resourceName: "checkMarkActive")
            
            cell.lblPlaced.textColor = UIColor(named: "boringGreen")
            cell.lblAccepted.textColor = UIColor(named: "boringGreen")
            cell.lblShopping.textColor = UIColor(named: "boringGreen")
            cell.lblOnTheWay.textColor = UIColor(named: "boringGreen")
            cell.lblDelivered.textColor = UIColor(named: "boringGreen")
            cell.lblReceived.text = order?.name
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        return CGFloat(0)
}
    
    
    
// Getting Order Histories
    func getOrdersInfo(customerId: String) {
        WebServiceManager.progressHudSetting()
        SVProgressHUD.show()
        let langId = APIManager.sharedInstance.languageId
        let url = ORDER_HISTORY + "customer_id=\(customerId)&language_id=" + langId
        Alamofire.request(  url , method: .get, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            SVProgressHUD.dismiss()
            switch(response.result) {
            case .success(_):
                if let data = response.result.value{
                    let orders = Mapper<Order>().mapArray(JSONObject: data)
                    self.orders = orders
                    self.collectionView.delegate = self
                    self.collectionView.dataSource = self
                    self.collectionView.reloadData()
                    if self.orders?.count != 0 {
                        self.noDataView.isHidden = true
                    }else {
                        self.noDataView.isHidden = false
                    }

                }
                break
                
            case .failure(_):
                APIManager.sharedInstance.customPOP(isError: true, message: ERROR_MESSAGE)
                break
                
            }
        }
        
    }

}
