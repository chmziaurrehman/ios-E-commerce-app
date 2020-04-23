//
//  AlertListController.swift
//  PatientApp
//
//  Created by Usman Javed on 12/6/16.
//  Copyright © 2016 Usman Javed. All rights reserved.
//

import UIKit

//typealias alertListCallback = (Any?) -> Void

class AlertListController: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource{

    //MARK:- Data Members
    @IBOutlet weak var tableview: UITableView!
//    var dataSource : [ListItem] = [ListItem(itemID: nil, itemValue: "-Select-")!]
    var dataSource : [ListItem] = []
    var listSelectedValueIndex : Int?
    var calbacks : getResponse?
    var isPopoverDismissed : Bool = false
    var contentSize : CGSize = CGSize(width: 375, height: 350)
    @IBOutlet weak var lblNoResultFound: UILabel!
    
    //MARK:- Life Cycle
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = []
    }
    
    init(dataSource : [ListItem]?, selectedValueIndex: Int?) {
        
        super.init(nibName: nil, bundle: nil)
        self.dataSource += dataSource!
//        self.dataSource = dataSource!
        if let rowIndex = selectedValueIndex {
            listSelectedValueIndex = rowIndex
        }
        if (dataSource?.count)! <= 7 {
            contentSize = CGSize(width: 375, height: (dataSource?.count)! * 44)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tableview.tableFooterView = UIView(frame: CGRect.zero)
        if let rowIndex = listSelectedValueIndex {
            tableview.selectRow(at: NSIndexPath(item: rowIndex + 0, section: 0) as IndexPath, animated: false, scrollPosition: .none)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    //MARK:- Private Helping Methods
    func updateDatasource(updatedDataSource : [ListItem], selectedRowIndex : Int?) -> Void {
        
        dataSource = updatedDataSource
        if let rowIndex = selectedRowIndex {
            listSelectedValueIndex = rowIndex
            tableview.selectRow(at: NSIndexPath(item: rowIndex + 1, section: 0) as IndexPath, animated: false, scrollPosition: .none)
        }
        
        if (dataSource.count <= 0) {
            lblNoResultFound.isHidden = false
        } else {
            lblNoResultFound.isHidden = true
        }
        tableview.reloadData()
    }
    
    // MARK: - Table Veiw Datasource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellIdentifier = "cellAlertList"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        if (cell == nil) {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
            cell?.selectionStyle = .blue
        }
        
        let listItem : ListItem = dataSource[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "Montserrat-Regular", size: 17.0)
        cell?.textLabel?.text = listItem.value(forKey: listItem.value!) as? String
        cell?.backgroundColor = UIColor.clear
        cell?.contentView.backgroundColor = UIColor.clear
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        calbacks!(dataSource[indexPath.row])
        dismissAlertController()
    }
    
    //MARK:- PopoverPresentationController Method & Delegate
    func showPopOverController(parentController : UIViewController, sourceRect: CGRect, sourceView : UIView,completion: @escaping getResponse) -> Void {

//        if ( [activityViewController respondsToSelector:@selector(popoverPresentationController)] ) {
//            // iOS8
//            activityViewController.popoverPresentationController.sourceView =
//            parentView;
//        }
        
        isPopoverDismissed = false
        self.modalPresentationStyle = .popover
//        _ = self.popoverPresentationController
        if let popover = self.popoverPresentationController {
            
            popover.delegate = self
            popover.sourceView = sourceView
            popover.sourceRect = sourceRect
            self.preferredContentSize = contentSize
        }
        
        parentController.present(self, animated: true) {
            if (self.dataSource.count <= 0) {
                self.lblNoResultFound.isHidden = false
            } else {
                self.lblNoResultFound.isHidden = true
            }
            self.tableview.reloadData()

        }
//        parentController.present(self, animated: true, completion:nil)
        calbacks = completion
        
//        if (dataSource.count <= 0) {
//            lblNoResultFound.isHidden = false
//        } else {
//            lblNoResultFound.isHidden = true
//        }
//        tableview.reloadData()
        
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController){
        
        isPopoverDismissed = true
//        calbacks!(nil)
    }
    
    func dismissAlertController () {
        
        isPopoverDismissed = true
//        dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: { () in
            
        })
    }
}









