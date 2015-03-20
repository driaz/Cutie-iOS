//
//  FavoritesViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 2/14/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

//will be observer - 
//NSnotification Center

//setup one class to be observer (FavoritesViewController)
//setup "posting the notification"

import UIKit
import Foundation

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var favoritesView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    
    var testDebugger = "testing123"
    let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "BlackLogo")
        let imageView = UIImageView(image:logo)
        self.navItem.titleView = imageView
        self.favoritesView.backgroundColor = UIColor.blackColor()

        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        println("view does appear upon click")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.favoritesView.dequeueReusableCellWithIdentifier("FavoritesCell") as PostCell
        let post = appDelegate.appDelegateFavorites[indexPath.row]
        cell.selectionStyle = .None
        cell.configureWithRedditPost(post)
        return cell

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = appDelegate.appDelegateFavorites.count
        return count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return favoritesView.frame.width * 1.0
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
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
