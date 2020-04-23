//
//  QDescriptionView.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 20/03/2020.
//  Copyright © 2020 Qareeb. All rights reserved.
//

import UIKit
import WebKit

class QDescriptionView: UIView {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var btnClose: UIButton!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBAction func btnClose(_ sender: Any) {
        self.removeFromSuperview()
    }

    func loadDescription(proDescription: String) -> Void {
        let htmlString = proDescription
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}
