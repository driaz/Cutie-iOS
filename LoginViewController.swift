//
//  LoginViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 1/17/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBLoginViewDelegate{

    @IBOutlet weak var BackgroundImage: UIImageView!
    
    @IBOutlet weak var createAccount: UIButton!
    
    @IBOutlet weak var fbLoginView: FBLoginView!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        var testThis = FBSession.activeSession().accessTokenData
        
        if (testThis != nil) {
            logInToFacebook()
            performSegueWithIdentifier("showTBVC", sender: self)
        }
        
        
        // This code is provided by parse, it is supposed to prompt the FB Login and pass FB Login data to Parse's backend. Currently it is getting me an error with the FBLoginView object I created (it shows "log in" even when the user is still logged in).
    }
    
    func logInToFacebook() {
        
        PFFacebookUtils.logInWithPermissions(fbLoginView.readPermissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            if user == nil {
                NSLog("Uh oh. The user cancelled the Facebook login.")
            } else if user.isNew {
                NSLog("User signed up and logged in through Facebook!")
            } else {
                NSLog("User logged in through Facebook!")
            }
            
        })
    }
    
    func facebookLoginDidComplete () {
        var testThis = FBSession.activeSession().accessTokenData
        
        if (testThis != nil) {
            logInToFacebook()
            performSegueWithIdentifier("showTBVC", sender: self)
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "observeApplicationDidBecomeActiveNotification", name: nil, object: nil)
    }
    
    
    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
            println("User Logged In")
            println("This is where you can perform a segue.")
            performSegueWithIdentifier("showTBVC", sender: self)
        
    }

    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        println("User name: \(user.name)")
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        println("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        println("Error: \(handleError.localizedDescription)")
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

}
