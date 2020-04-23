//
//  CustomAlertViewController.swift
//  PatientApp
//
//  Created by Usman Javed on 11/23/16.
//  Copyright © 2016 Usman Javed. All rights reserved.
//

import UIKit

enum CustomAlertType {
    case none
    case alertDatePicker
    case alertListPicker
}

typealias getResponse = (Any?) -> Void

class CustomAlertViewController: UIViewController , UIPopoverPresentationControllerDelegate{

    //MARK: - Data Members

    var calbacks : getResponse?
    var customAlertType = CustomAlertType.none
    var customDatePicker : CustomDateTimePicker? = nil
    var customListPicker : CustomListPickerView? = nil
    var listPickerDataSource : [ListItem] = []
    var listSelectedValueIndex : Int = 0
    var selectedDate : Date? = nil
    @IBOutlet weak var containerView: UIView!
    var isPopoverDismissed : Bool = false
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if customAlertType == .alertDatePicker {
            loadDateTimePicker()
        } else if customAlertType == .alertListPicker {
            loadListPicker()
        }
    }
    
    init(alertType: CustomAlertType, dataSource : [ListItem]?, selectedValueIndex: Int?, selectedDate date : Date = Date())
    {
        super.init(nibName: nil, bundle: nil)
        if alertType == .alertDatePicker {
            selectedDate = date
            customAlertType = CustomAlertType.alertDatePicker
        } else if alertType == .alertListPicker {
            customAlertType = CustomAlertType.alertListPicker
            listPickerDataSource = dataSource!
            listSelectedValueIndex = selectedValueIndex!
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
    }
    
    //MARK: - Show Popover Controller
    func showPopOverController(parentController : UIViewController, sourceRect: CGRect, sourceView : UIView,completion: @escaping getResponse) -> Void {

        self.modalPresentationStyle = .popover
        _ = self.popoverPresentationController
        if let popover = self.popoverPresentationController {

            popover.delegate = self
            popover.sourceView = sourceView
            popover.sourceRect = sourceRect
            self.preferredContentSize = CGSize(width: 350, height: 260)
        }
        parentController.present(self, animated: true, completion:nil)
        
        calbacks = completion
    }
    
    //MARK: - Button Clicks
    @IBAction func btnDone(_ sender: Any) {
        

        if customAlertType == .alertDatePicker {
            
            calbacks!(customDatePicker?.getSelectedDate())
        } else if customAlertType == .alertListPicker {
            
            calbacks!(customListPicker?.getSelectedValue())
        }

        dismissAlertController()
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        dismissAlertController()
    }
    
    //MARK: - Date Picker Methods
    func loadDateTimePicker() -> Void {
        
        customDatePicker = CustomDateTimePicker.customView()!
        containerView.addSubview(customDatePicker!)
        if let _date = selectedDate {
         
            customDatePicker?.setSelectedDate(date: _date)
        }
    }
    
    func updateDateTimePicker(Date date : Date) {
        
        if let _customDatePicker = customDatePicker {
            
            if let _date = selectedDate {
                
                _customDatePicker.setSelectedDate(date: _date)
            }
        }
    }
    
    //MARK: - List Picker Methods
    func loadListPicker() -> Void {
        customListPicker = CustomListPickerView.customView()!
        customListPicker?.dataSource = listPickerDataSource
        customListPicker?.pickerview.selectRow(listSelectedValueIndex, inComponent: 0, animated: false)
        containerView.addSubview(customListPicker!)
    }
    
    func updateListPicker(updatedDataSource : [ListItem], selectedRowIndex : Int) -> Void {
        customListPicker?.dataSource = updatedDataSource
        customListPicker?.pickerview.selectRow(selectedRowIndex, inComponent: 0, animated: false)
        customListPicker?.pickerview.reloadAllComponents()
    }
    
    //MARK: - UIPopoverPresentationController Delegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController){
        
        isPopoverDismissed = true
        print("")
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        
        if customAlertType == .alertDatePicker {
            
            return false
        }
        return true
    }
    
    func dismissAlertController () {
        
        isPopoverDismissed = true
        dismiss(animated: true, completion: nil)
    }

}
