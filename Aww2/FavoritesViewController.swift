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

class FavoritesViewController: UITableViewController, UIPageViewControllerDataSource {
    
    var posts = [RedditPost]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "BlackLogo")
        self.navigationItem.titleView = UIImageView(image:logo)
        self.tableView.backgroundColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // init saved favorite posts
        if let postsData = NSUserDefaults.standardUserDefaults().dataForKey("RedditPosts") {
            posts = NSKeyedUnarchiver.unarchiveObjectWithData(postsData) as! [RedditPost]
        }
        
        for post in posts {
            post.image = imageWithFilename(post.filename!)
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPageViewController" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let post = posts[indexPath.row]
                
                let pageVC = segue.destinationViewController as! UIPageViewController
                pageVC.dataSource = self
                
                let logo = UIImage(named: "BlackLogo")
                pageVC.navigationItem.titleView = UIImageView(image:logo)
                
                let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
                detailVC.index = indexPath.row
                detailVC.detailPost = posts[indexPath.row]
                
                pageVC.setViewControllers([detailVC], direction: .Reverse, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - UITableView data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell") as! PostCell
        
        configureRedditCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 320.0
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = posts[indexPath.row]
        
        return post.fittingHeight ?? 320.0
    }
    
    // MARK: - UIPageViewController data source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let currentDetailVC = viewController as! DetailViewController
        let positionIndex = currentDetailVC.index - 1
        
        if positionIndex < 0 {
            return nil;
        }
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailVC.index = positionIndex
        if positionIndex < posts.count {
            let post = posts[positionIndex]
            configureDetailViewController(detailVC, withPost:post)
        }
        
        return detailVC
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let currentDetailVC = viewController as! DetailViewController
        let positionIndex = currentDetailVC.index + 1
        
        if positionIndex > posts.count - 1 {
            return nil
        }
        
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailVC.index = positionIndex
        let post = posts[positionIndex]
        configureDetailViewController(detailVC, withPost:post)
        
        return detailVC
    }
    
    // MARK: - Helpers
    
    func configureRedditCell(cell: PostCell, atIndexPath indexPath: NSIndexPath) {
        
        // This function is called from the tableView(_:cellForRowAtIndexPath:) function in the ViewController class.
        // Within the retrieveAndSetImage function we can determine if the post's image is missing data. If it is,
        // we need to return something that tells the tableViewCellForRowAtIndexPath function not to create a cell.
        
        let post = posts[indexPath.row]
        cell.titleLabel.text = "  \(post.title)"
        cell.postImageView.image = post.image
    }
    
    func configureDetailViewController(detailVC: DetailViewController, withPost post: RedditPost) {
        
        detailVC.detailPost = post
        if detailVC.isViewLoaded() {
            detailVC.setRedditPost()
            detailVC.activityIndicator.stopAnimating()
        }
    }
    
    func imageWithFilename(filename: String) -> UIImage {
        
        var url = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0] as! NSURL
        url = url.URLByAppendingPathComponent(filename)
        let data = NSData(contentsOfURL: url)
        return UIImage(data: data!, scale: UIScreen.mainScreen().scale)!
    }
}
