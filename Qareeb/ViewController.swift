//
//  ViewController.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 15/02/2019.
//  Copyright © 2019 MDVision. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView: UIProgressView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        // Do any additional setup after loading the view, typically from a nib.
        let myURL = URL(string: "https://careeb.com/development/index.php?route=store/store&seller_id=1")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        self.webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil);

    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            print(self.webView.estimatedProgress);
            self.progressView.progress = Float(self.webView.estimatedProgress);        }
    }
    @IBAction func btnBack(_ sender: Any) {
        webView.goBack()
    }
    @IBAction func btnForword(_ sender: Any) {
        webView.goForward()
    }
}

