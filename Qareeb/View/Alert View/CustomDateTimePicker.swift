//
//  CustomDateTimePicker.swift
//  PatientApp
//
//  Created by Usman Javed on 11/24/16.
//  Copyright © 2016 Usman Javed. All rights reserved.
//

import UIKit

class CustomDateTimePicker: UIView {

    @IBOutlet weak var dateTimePicker: UIDatePicker!
    
    class func customView() -> CustomDateTimePicker? {
        
         let customDateTimePicker = Bundle.main.loadNibNamed("CustomDateTimePicker", owner: nil, options: nil)?[0] as? CustomDateTimePicker
        if customDateTimePicker != nil {
            return customDateTimePicker!
        }

        return nil
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    func setSelectedDate(date : Date) {
        
        dateTimePicker.date = date
    }
    
    func getSelectedDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.current
//        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: dateTimePicker.date)
    }
}
