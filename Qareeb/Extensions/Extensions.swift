//
//  Extensions.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 15/02/2019.
//  Copyright © 2019 MDVision. All rights reserved.
//

import UIKit
import Kingfisher
import ImageSlideshow
import AlamofireImage

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}


//MARK:- Label Extention.
extension UILabel {
    func addTextSpacing(val: Float) {
        if let textString = text {
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.kern, value: val, range: NSRange(location: 0, length: attributedString.length - 1))
            attributedText = attributedString
        }
    }
    
    
}

extension String {
    func validEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-" +
            "z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) {
            return self
        }
        return String( Array(self).prefix(upTo: n) )
    }
    
    
    
    public var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
    
    //MARK:- Apply pattern on textfield
    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(encodedOffset: index)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }
}


private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
}

extension UIView {
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
extension UIViewController {
    class func fromNib<T: UIViewController>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}

extension Double {
    
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return Darwin.round(self * divisor) / divisor
    }
    
}
extension Notification.Name {
    static let getCart = Notification.Name("getCart")
    static let callHomePage = Notification.Name("callHomePage")
    static let goToCart = Notification.Name("goToCart")
    static let callSpecialViewController = Notification.Name("callSpecialViewController")
    static let hideNavigationBar = Notification.Name("hideNavigationBar")

}


extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        
        // Swift 4.2 and above
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)

    }
    
}

extension UIImageView {
    func loadImage(from url: String?, isBaseUrl: Bool) {
        if let imageUrl = url?.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            var urlString = imageUrl
            if isBaseUrl {
                urlString = IMAGE_BASE_URL + imageUrl
            }
            let resource = ImageResource(downloadURL:  URL(string: urlString)! , cacheKey: imageUrl)
            kf.setImage(with: resource, placeholder: UIImage(named: IMAGE_PLACEHOLDER), options: [], progressBlock: { (recievedSize, totalSize) in
            }, completionHandler: nil)
        }
    }
    
    
}

extension Dictionary {
    func merge(dict: Dictionary<Key,Value>) -> Dictionary<Key,Value> {
        var mutableCopy = self
        for (key, value) in dict {
            // If both dictionaries have a value for same key, the value of the other dictionary is used.
            mutableCopy[key] = value
        }
        return mutableCopy
    }
}

extension ImageSlideshow {
    func setBanner(banners: [BannerImage])  {
    
        var sorces = [AlamofireSource]()
        for  i in 0..<banners.count {
            if let url = banners[i].image {
                sorces.append(AlamofireSource(urlString: IMAGE_BASE_URL + url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
            }
        }
        DispatchQueue.main.async {
            self.slideshowInterval = 4.0
            self.setImageInputs(sorces)
        }
    }
    
    func setBanner2(banners: [BannerImage])  {
        
        var sorces = [AlamofireSource]()
        for  i in 0..<banners.count {
            if let url = banners[i].image {
                sorces.append(AlamofireSource(urlString: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
            }
        }
        DispatchQueue.main.async {
            self.slideshowInterval = 4.0
            self.contentMode = .scaleToFill
            self.contentScaleMode = .scaleAspectFill
            self.setImageInputs(sorces)
        }
    }
    
    func setProductImages(images: [String])  {
        
        var sorces = [AlamofireSource]()
        for  i in 0..<images.count {
            let url = images[i]
            sorces.append(AlamofireSource(urlString: url.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)!)
        }
        DispatchQueue.main.async {
            self.contentMode = .scaleToFill
            self.contentScaleMode = .scaleAspectFill
            self.setImageInputs(sorces)
        }
    }
}
