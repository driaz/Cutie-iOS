//
//  LoginViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 1/17/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var BackgroundImage: UIImageView!
    
    @IBOutlet weak var createAccount: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        createAccount.layer.borderColor = UIColor.whiteColor().CGColor
        
        var fbData = FBSession.activeSession().accessTokenData
        
        if (fbData != nil) {
            let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainfeed") as ViewController
            
            self.showViewController(viewController, sender: nil)
            
            println("testing 123")
        }
        else {
            println("fbData is nil")
            
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

}
