//
//  UITextViewX.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 25/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//
import UIKit

@IBDesignable
class UITextViewX: UITextView {
    
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
}
