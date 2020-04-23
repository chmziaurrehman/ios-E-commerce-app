//
//  ListItem.swift
//  PatientApp
//
//  Created by Usman Javed on 11/28/16.
//  Copyright © 2016 Usman Javed. All rights reserved.
//

import UIKit
import SwiftKVC
import ObjectMapper

class ListItem: NSObject, Object {
    
    var ID : String?
    var value : String?
    var isSelected : Bool = false
    
    override init() {
        super.init()
    }
    
    convenience required init?(itemID : String?, itemValue : String?) {
        self.init()
        self.ID = itemID
        self.value = itemValue
    }
    
    convenience required init?(itemID : String?, itemValue : String?, isSelected : Bool) {
        self.init()
        self.ID = itemID
        self.value = itemValue
        self.isSelected = isSelected
    }
}
