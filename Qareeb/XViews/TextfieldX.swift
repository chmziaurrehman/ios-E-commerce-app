//
//  TextfieldX.swift
//  American One
//
//  Created by M Zia Ur Rehman Ch. on 27/10/2017.
//  Copyright © 2017 M Zia Ur Rehman Ch. All rights reserved.
//

import UIKit

class TextfieldX: UITextField, UITextFieldDelegate {
let bottomLine = CALayer()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func bottomBorder() {
        delegate = self
        bottomLine.frame = CGRect(x: 0, y: frame.height - 2, width: frame.width, height: 2)
        if text == "" {
            bottomLine.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 0.6979366373)
        }else {
            bottomLine.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        }
        
        borderStyle = UITextField.BorderStyle.none
        layer.addSublayer(bottomLine)
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        bottomLine.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
    }
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if textField.text == "" {
            bottomLine.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 0.7014953988)
        }else {
            bottomLine.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        }
        
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
  

}
