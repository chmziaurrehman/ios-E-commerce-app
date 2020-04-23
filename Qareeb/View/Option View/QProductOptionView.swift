//
//  QProductOptionView.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 27/08/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit

class QProductOptionView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var productWithDetail : Product?
    var productOptions = [Product_option_value]()
    @IBOutlet weak var animatedConst: NSLayoutConstraint!
    
    var selectedOptions:(()->Void)?
    
    func loadData()  {
        tableView.register(UINib(nibName: "QVarientCell", bundle: nil), forCellReuseIdentifier: "QVarientCell")
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelection = true
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
        
        for i  in 0..<(self.productWithDetail?.options?.count ?? 0) {
            if self.productWithDetail?.options?[i].product_option_value?.count != 0 && self.productWithDetail?.options?[i].type?.lowercased() != "checkbox"{
                DispatchQueue.main.async {
                    self.tableView.selectRow(at: IndexPath(row: 0, section: i), animated: true, scrollPosition: .none)
                    let cell: QVarientCell = self.tableView.cellForRow(at: NSIndexPath(row: 0, section: i) as IndexPath)! as! QVarientCell
                    cell.radioButton.backgroundColor =  #colorLiteral(red: 0.4431372549, green: 0.6980392157, blue: 0.3882352941, alpha: 1)
                    self.productWithDetail?.options?[i].product_option_value?[0].isSelected = true
                }
            }
        }
        
    }

    func loadAnimatedView() {
        self.layoutIfNeeded()
        self.animatedConst.constant = 120
        UIView.animate(withDuration: 0.5, animations: {
            self.layoutIfNeeded()
        }) { (true) in
            self.loadData()
        }
    }
    
    @IBAction func btnDone(_ sender: Any) {
//        for i  in 0..<(self.productWithDetail?.options?.count ?? 0) {
//            for j  in 0..<(self.productWithDetail?.options?[i].product_option_value?.count ?? 0) {
//                if self.productWithDetail?.options?[i].product_option_value?[j].isSelected == true {
//                    print("\(self.productWithDetail?.options?[i].name) ------ \(self.productWithDetail?.options?[i].product_option_value?[j].name)")
//                }
//            }
//        }
        self.selectedOptions?()
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.animatedConst.constant = (self.window?.frame.height)!
            self.layoutIfNeeded()
        }) { (true) in
            self.removeFromSuperview()
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.productWithDetail?.options?.count ?? 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.productWithDetail?.options?[section].product_option_value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QVarientCell", for: indexPath) as! QVarientCell
        let optionItem = self.productWithDetail?.options?[indexPath.section].product_option_value?[indexPath.row]
        let type = self.productWithDetail?.options?[indexPath.section].type?.lowercased()
        if type == "select" || type == "radio" {
            cell.checkboxOuterView.isHidden = true
        } else {
            cell.checkboxOuterView.isHidden = false
        }
        if self.productWithDetail?.options?[indexPath.section].product_option_value?[indexPath.row].isSelected == true {
            cell.radioButton.backgroundColor =  #colorLiteral(red: 0.4431372549, green: 0.6980392157, blue: 0.3882352941, alpha: 1)
        }else {
            cell.radioButton.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        cell.lblTitle.text = optionItem?.name
        cell.lblPrice.text = optionItem?.price
        return cell
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let type = self.productWithDetail?.options?[indexPath.section].type?.lowercased()
        if type == "select" || type == "radio" {
            for i in 0...tableView.numberOfRows(inSection: indexPath.section) - 1 {
                let cell: QVarientCell = tableView.cellForRow(at: NSIndexPath(row: i, section: indexPath.section) as IndexPath)! as! QVarientCell
                if (i == indexPath.row) {
                    cell.radioButton.backgroundColor =  #colorLiteral(red: 0.4431372549, green: 0.6980392157, blue: 0.3882352941, alpha: 1)
                    self.productWithDetail?.options?[indexPath.section].product_option_value?[i].isSelected = true
                    cell.isSelected = false
                } else {
                    cell.accessoryType = .none
                    cell.radioButton.backgroundColor =  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    self.productWithDetail?.options?[indexPath.section].product_option_value?[i].isSelected = false
                }
            }
        }
        else {
            self.productWithDetail?.options?[indexPath.section].product_option_value?[indexPath.row].isSelected = true
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let type = self.productWithDetail?.options?[indexPath.section].type?.lowercased()
        if type == "radio" || type == "select"{
        } else {
            self.productWithDetail?.options?[indexPath.section].product_option_value?[indexPath.row].isSelected = false
        }
    }

    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //Custom header view for multiple stores
        
        let header = Bundle.main.loadNibNamed("QVarientHeaderCell", owner: self, options: nil)?.last as! QVarientHeaderCell
        
        let sectionItem = self.productWithDetail?.options?[section]
        header.lblTitle.text = sectionItem?.name
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
