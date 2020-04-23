//
//  UITextfieldX.swift
//  Sehat Kahani
//
//  Created by M Zia Ur Rehman Ch. on 28/09/2017.
//  Copyright © 2017 M Zia Ur Rehman Ch. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class UITextfieldX: UITextField {
    
    // MARK: - Shadow
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    
    
//    @IBInspectable  public var Ratio: CGFloat {
//        get {
//            return layer.cornerRadius / frame.width
//        }
//        
//        set {
//            // Make sure that it's between 0.0 and 1.0. If not, restrict it
//            // to that range.
//            let normalizedRatio = max(0.0, min(1.0, newValue))
//            layer.cornerRadius = frame.width * normalizedRatio
//        }
//    }
    
//    @IBInspectable public var roundedCorner: CGFloat = 0 {
//        didSet {
//            if roundedCorner == 1 {
//                layer.cornerRadius = layer.frame.height / 1.8
//            }
//        }
//    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var shadowOpacity: CGFloat = 0 {
        didSet {
            layer.shadowOpacity = Float(shadowOpacity)
        }
    }
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear {
        didSet {
            layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable public var shadowRadius: CGFloat = 0 {
        didSet {
            layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable public var shadowOffsetY: CGFloat = 0 {
        didSet {
            layer.shadowOffset.height = shadowOffsetY
        }
    }
}
