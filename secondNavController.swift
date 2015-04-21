//
//  secondNavController.swift
//  Aww2
//
//  Created by Daniel Riaz on 2/16/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

import UIKit

class secondNavController: UINavigationController {

    @IBOutlet var navTitle: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.selectedImage = UIImage(named: "paw_print_filled")
        
//        self.navTitle.title = "testing 123"
        
        
        
    
    

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
