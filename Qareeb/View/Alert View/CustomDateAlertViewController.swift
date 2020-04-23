//
//  CustomDateAlertViewController.swift
//  PatientApp
//
//  Created by Usman Javed on 1/20/17.
//  Copyright © 2017 Usman Javed. All rights reserved.
//

import UIKit

typealias datePickCallback = (String?, Date) -> Void

class CustomDateAlertViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    var callbacks : datePickCallback?
    var selectedDate : Date? = nil
    var isPopoverDismissed : Bool = false
    @IBOutlet weak var datePicker: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.date = selectedDate!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(selectedDate date : Date = Date()) {
        
        super.init(nibName: nil, bundle: nil)
        selectedDate = date
    }
    
    func setMax(Date _date : Date) {
        
        if datePicker != nil {
            
            datePicker.maximumDate = _date
        }
    }
    
    func getDateString() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: datePicker.date)
    }
    
    func getDate() -> Date {
        
        return datePicker.date
    }
    
    //MARK: - Show Popover Controller
    func showPopOverController(parentController : UIViewController, sourceRect: CGRect, sourceView : UIView,completion: @escaping datePickCallback) -> Void {
        
        
        self.modalPresentationStyle = .popover
        _ = self.popoverPresentationController
        if let popover = self.popoverPresentationController {
            
            popover.delegate = self
            popover.sourceView = sourceView
            popover.sourceRect = sourceRect
            self.preferredContentSize = CGSize(width: 350, height: 260)
        }
        parentController.present(self, animated: true, completion:nil)
        callbacks = completion
    }
    
    //MARK: - Button Clicks
    @IBAction func btnDone(_ sender: Any) {
        
        callbacks!(getDateString(), getDate())
        dismissAlertController()
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        
        dismissAlertController()
    }
    
    //MARK: - UIPopoverPresentationController Delegate
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController){
        
        isPopoverDismissed = true
        print("")
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        
        return false
    }
    
    func dismissAlertController () {
        
        isPopoverDismissed = true
        dismiss(animated: true, completion: nil)
    }
}
