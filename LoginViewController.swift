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
        
        if PFUser.currentUser() != nil {
            performSegueWithIdentifier("showTBVC", sender: self)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - FBSDKLoginButtonDelegate
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if error != nil {
            UIAlertView(title: nil, message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            return
        }
        
        PFFacebookUtils.logInInBackgroundWithAccessToken(result.token) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                self.performSegueWithIdentifier("showTBVC", sender: self)
            } else {
                UIAlertView(title: nil, message: error?.localizedDescription, delegate: nil, cancelButtonTitle: "OK").show()
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }
}
