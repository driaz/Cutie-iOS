//
//  PageViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 2/19/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {

    @IBOutlet var navItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let logo = UIImage(named: "BlackLogo")
        let imageView = UIImageView(image:logo)
        self.navItem.titleView = imageView
        // Do any additional setup after loading the view.
        
        self.automaticallyAdjustsScrollViewInsets = false
        
//        self.edgesForExtendedLayout = UIRectEdge.None
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
