//
//  FavoritesViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 2/14/15.
//  Copyright (c) 2015 Daniel Riaz. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var favoritesView: UITableView!
    
    var FVCArray = [RedditPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func passDataToFVC(passedArray: [RedditPost]) {
//        self.FVCArray = passedArray
//    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.favoritesView.dequeueReusableCellWithIdentifier("favoritesCell") as PostCell
        let post = FVCArray[indexPath.row]
        cell.selectionStyle = .None
        cell.configureWithRedditPost(post)
        return cell

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FVCArray.count
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
