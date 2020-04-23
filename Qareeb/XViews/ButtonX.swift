//
//  ButtonX.swift
//  American One
//
//  Created by M Zia Ur Rehman Ch. on 27/10/2017.
//  Copyright © 2017 M Zia Ur Rehman Ch. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonX: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - Border
    
    @IBInspectable public var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable public var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable public var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = layer.frame.height * cornerRadius
        }
    }
    @IBInspectable public var cRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cRadius
        }
    }
    @IBInspectable public var roundedCorner: CGFloat = 0 {
        didSet {
            if roundedCorner == 1 {
                layer.cornerRadius = layer.frame.height / 2
            }
        }
    }
    // MARK: - Shadow
    
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
    
    func cornerRadius1() {
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    func cornerRadius2() {
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        
//        layer.borderColor = APIManager.sharedInstance.firstColor.cgColor
    }
    func cornerRadius3() {
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.7058823529, green: 0.2666666667, blue: 0.2666666667, alpha: 1)
    }
}

