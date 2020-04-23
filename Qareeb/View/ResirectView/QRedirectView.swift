//
//  QRedirectView.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 19/06/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import WebKit

class QRedirectView: UIView , WKNavigationDelegate{

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressBar: UIProgressView!
    var redirectedUrlId: String!
    var dismissView:(()->Void)!
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        webView.navigationDelegate = self
    }
 
    @IBAction func btnClose(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
         self.progressBar.setProgress(0.1, animated: false)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.progressBar.setProgress(1.0, animated: true)
    }
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressBar.setProgress(1.0, animated: true)
    
        if let redirectedUrl = webView.url?.absoluteString {
           if(redirectedUrl.contains("facebook")) {
                APIManager.sharedInstance.customPOP(isError: false, message: "Transaction successfull")
                self.dismissView()
                self.removeFromSuperview()
           } else if(redirectedUrl.contains("google")) {
            APIManager.sharedInstance.customPOP(isError: false, message: "Transaction failed")
            self.removeFromSuperview()
            }
            
        }
    }
    
}
