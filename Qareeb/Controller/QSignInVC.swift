//
//  QSignInVC.swift
//  Qareeb
//
//  Created by M Zia Ur Rehman Ch. on 16/02/2019.
//  Copyright © 2019 Qareeb. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn


class QSignInVC: UIViewController, FBSDKLoginButtonDelegate , GIDSignInDelegate, GIDSignInUIDelegate {

    let manager = FBSDKLoginManager()
    let faceBooklogInButton: FBSDKLoginButton = {
        var button = FBSDKLoginButton()
        button.readPermissions = ["public_profile","email"]
        button.loginBehavior = .web
        
        if FBSDKAccessToken.current() != nil {
            print("loged in")
        }else {
            print("not loged in")
        }
        return button
    }()

    @IBOutlet weak var btnGoogleSignIn: ButtonX!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    //Localizable labels : -
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    @IBOutlet weak var lblForgotPassword: UIButton!
    @IBOutlet weak var lblLogInWith: UILabel!
    @IBOutlet weak var lblOr: UILabel!
    @IBOutlet weak var lblLogInButton: UIButton!
    @IBOutlet weak var lblSignUpButton: UIButton!
    
    var user = GIDGoogleUser()
    var previousVC : UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        localizeStrings()
//        txtEmail.text = "smsamalik@gmail.com"
//        txtPassword.text = "123456"
        
        faceBooklogInButton.delegate = self
        btnGoogleSignIn.addTarget(self, action: #selector(btnGoogle(_:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    //Localization configrations
    func localizeStrings() {
        lblEmail.text = LocalizationSystem.shared.localizedStringForKey(key: "Email", comment: "")
        lblPassword.text = LocalizationSystem.shared.localizedStringForKey(key: "password", comment: "")
        lblOr.text = LocalizationSystem.shared.localizedStringForKey(key: "And", comment: "")
        lblLogInWith.text = LocalizationSystem.shared.localizedStringForKey(key: "Login_with", comment: "")
        lblForgotPassword.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "ForgotPassword", comment: ""), for: .normal)
        lblLogInButton.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "LOGIN", comment: ""), for: .normal)
        lblSignUpButton.setTitle(LocalizationSystem.shared.localizedStringForKey(key: "Signup", comment: ""), for: .normal)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK GOOGLE SIGNIN DELEGATES AND BUTTON ACTION
    @objc func btnGoogle(_ sender : ButtonX)  {
        GIDSignIn.sharedInstance().signOut()
        
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.signIn()
    }
    //GOOGLE SIGNIN DELEGATE
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            
            self.user = user
            // Perform any operations on signed in user here.
            APIManager.sharedInstance.loginUserService(email: self.user.profile.email, password: "", controller: self, previousVC: previousVC, isSocial: true, gData: self.user, fData: nil)

        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        APIManager.sharedInstance.customPOP(isError: true, message: "Disconnect google user.")
        // ...
    }
    
    
    
    
    // MARK : - FACEBOOK LOGIN BUTTON
    
    @IBAction func fbLogIn(_ sender: Any) {
//    FBSDKAccessToken.setCurrent(nil)
//    FBSDKProfile.setCurrent(nil)
    
//    manager.logOut()
    faceBooklogInButton.sendActions(for: .touchUpInside)
}

    // MARK : - FACEBOOK LOGIN DELEGATE IMPLEMENTATION.
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        
        
        print("\nLogIn func\n")
        //            fetchProfile()
        return true
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error.localizedDescription)
        } else if result.isCancelled {
            print("user cancelled log request")
        } else {
            print("user loged in")
            fetchProfile()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
        FBSDKAccessToken.setCurrent(nil)
        FBSDKProfile.setCurrent(nil)
        
        let manager = FBSDKLoginManager()
        manager.logOut()
        
        print(" facebook Loged out")
    }
    
    
    func fetchProfile() {
        
        print("\nfetch profile\n")

        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, first_name, last_name, id, gender, picture.type(large)"])?.start(completionHandler: { (connection, result, error) in
            if error != nil {
                print(error!.localizedDescription)
            }else {
                
                let rslt = result as! NSDictionary

                let email = rslt["email"] as! String
                
                APIManager.sharedInstance.loginUserService(email: email, password: "", controller: self, previousVC: self.previousVC, isSocial: true, gData: nil, fData: result)
                
            }
        })
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let destinationVC = segue.destination as? QSignUpVC
        destinationVC?.previousVC = self.previousVC
    }
    
    @IBAction func txtIsValid(_ sender: UITextField) {
        if !(sender.text?.validEmail())! && sender.text != "" {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter a valid email address" )
        }
    }
    @IBAction func btnForgotPassword(_ sender: Any) {
    }
    
    @IBAction func btnLogInWithFacebook(_ sender: Any) {
    }
    @IBAction func btnLogInWithGoogle(_ sender: Any) {
    }
    @IBAction func btnLogInWithTwitter(_ sender: Any) {
    }
    
    @IBAction func btnLogIn(_ sender: Any) {
        if txtPassword.text != "" && (txtEmail.text != "" && (txtEmail.text?.validEmail())!) {
            
            APIManager.sharedInstance.loginUserService(email: self.txtEmail.text!.removingWhitespaces(), password: self.txtPassword.text!, controller: self, previousVC: previousVC, isSocial: false, gData: nil, fData: nil)
            
        }else if txtEmail.text == "" {
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter password" )
        }else if txtPassword.text == ""{
            APIManager.sharedInstance.customPOP(isError: true, message: "Please enter a valid email address" )
        }
    }
    
 
}

