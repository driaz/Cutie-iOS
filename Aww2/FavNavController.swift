//
//  FavNavController.swift
//  Aww2
//
//  Created by Daniel Riaz on 3/10/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

import UIKit

class FavNavController: UINavigationController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarItem.selectedImage = UIImage(named: "heart_filled")
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
}
