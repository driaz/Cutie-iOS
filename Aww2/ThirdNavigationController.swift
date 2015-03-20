//
//  ThirdNavigationController.swift
//  Aww2
//
//  Created by Daniel Riaz on 3/17/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

//This navigation controller is pointless right now...it's used only to link

import UIKit

class ThirdNavigationController: UINavigationController {

    @IBOutlet var navItem: UINavigationItem!
    
    @IBOutlet weak var navBar: UINavigationBar!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.navItem.title = "test test"
        

        // Do any additional setup after loading the view.
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
