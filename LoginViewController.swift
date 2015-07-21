//
//  LoginViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 1/17/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var BackgroundImage: UIImageView!
    
    @IBOutlet weak var fbLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fbLoginButton.readPermissions = ["public_profile", "email", "user_friends"];
        fbLoginButton.delegate = self
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            UIAlertView(title: nil, message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        if let token = result?.token {
            PFFacebookUtils.logInInBackgroundWithAccessToken(token) {
                (user: PFUser?, error: NSError?) -> Void in
                if user != nil {
                    self.view.window?.rootViewController = self.storyboard?.instantiateViewControllerWithIdentifier("tabBarController") as? UIViewController
                } else {
                    UIAlertView(title: nil, message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
                }
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
}
