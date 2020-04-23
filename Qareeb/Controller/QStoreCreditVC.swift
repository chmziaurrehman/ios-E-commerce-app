//
//  QStoreCreditVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 05/03/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QStoreCreditVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    var creditTransactions: CreditTransactions?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "QCreditTransactionsCell", bundle: nil), forCellWithReuseIdentifier: "QCreditTransactionsCell")
        
        localizeStrings()
        screenWidth = self.view.frame.width
        screenHeight = self.view.frame.height
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
        layout.itemSize = CGSize(width: screenWidth, height: self.view.frame.width / 4)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        getStoreCreditTransactions()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        NotificationCenter.default.post(name: .hideNavigationBar, object: nil)
    }
    override func viewWillLayoutSubviews() {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    //Localization configrations
    func localizeStrings() {
        title = LocalizationSystem.shared.localizedStringForKey(key: "StoreCredit", comment: "")
        
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
extension QStoreCreditVC:  UICollectionViewDelegate ,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout  {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.creditTransactions?.result?.transactions?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "QCreditTransactionsCell", for: indexPath) as!  QCreditTransactionsCell
            let transaction = self.creditTransactions?.result?.transactions?[indexPath.item]
                cell.lblCredit.text = transaction?.amount
                cell.lblDate.text = transaction?.date_added
                cell.lblDescription.text = transaction?.desc
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
        
        return CGFloat(5)
}
    
    
    
    
    
    
    // GET STORE CREDIT TRANSACTIONS
    
    func getStoreCreditTransactions() {
        guard let customerId = APIManager.sharedInstance.getCustomer()?.customer_id else {
            APIManager.sharedInstance.customPOP(isError: true, message: LocalizationSystem.shared.localizedStringForKey(key: "please_login_first", comment: ""))
            return
        }
        let languageId = APIManager.sharedInstance.getLanguage()!.id
        let params = [
                        "customer_id"       : customerId,
                        "language_id"       : languageId
            ] as [String : AnyObject]
        let header = ["Content-Type" : "application/x-www-form-urlencoded"]
        WebServiceManager.poost(params: params, serviceName: STORE_CREDIT_TRANSACTIONS, header: header, serviceType: "ADD TO CART PRODUCT" , modelType: CreditTransactions.self, success: { (response) in
            let data = (response as! CreditTransactions)
            if data.msg == "success" {
                self.creditTransactions = data
                self.collectionView.delegate = self
                self.collectionView.dataSource = self
                self.collectionView.reloadData()
            }else {
            }
            
        }, fail: { (error) in
            APIManager.sharedInstance.customPOP(isError: true, message: error.localizedDescription)
            debugPrint(error)
        }, showHUD: true)
    }
}
