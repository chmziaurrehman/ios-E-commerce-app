//
//  UIImageX.swift
//  American One
//
//  Created by M Zia Ur Rehman Ch. on 08/11/2017.
//  Copyright © 2017 M Zia Ur Rehman Ch. All rights reserved.
//

import UIKit

@IBDesignable
class UIImageX: UIImageView {

    func imageCorner()  {
        layer.cornerRadius = frame.height / 2
    }
    
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
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
