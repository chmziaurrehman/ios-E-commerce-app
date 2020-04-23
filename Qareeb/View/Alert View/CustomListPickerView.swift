//
//  CustomListPickerView.swift
//  PatientApp
//
//  Created by Usman Javed on 11/24/16.
//  Copyright © 2016 Usman Javed. All rights reserved.
//

import UIKit

class CustomListPickerView: UIView, UIPickerViewDataSource, UIPickerViewDelegate{

    @IBOutlet weak var pickerview: UIPickerView!
    var dataSource : [ListItem] = []
    var selectedValue = ListItem()
   
    class func customView() -> CustomListPickerView? {
        
        let customListPickerView = Bundle.main.loadNibNamed("CustomListPickerView", owner: nil, options: nil)?[0] as? CustomListPickerView
        if customListPickerView != nil {
            return customListPickerView!
        }
        
        return nil
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    override func awakeFromNib() {
        
    }
    
    func getSelectedValue() -> ListItem {
        
        return selectedValue
    }
    
    //MARK: - Delegates and data sources
    //MARK: Data Sources
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return dataSource.count
    }
    
    //MARK: Delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[row].value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedValue = dataSource[row]
    }

}
