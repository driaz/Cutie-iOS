//
//  ViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 11/21/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITraitEnvironment {
    
    @IBOutlet var postView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var footerActivityIndictor: UIActivityIndicatorView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var isLoadingData = false
    var redditPostArray = [RedditPost]()
    var afterValue: String = String()
//    internal var currentIndexPath: NSIndexPath? = NSIndexPath()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectReddit()
        
        let logo = UIImage(named: "BlackLogo")
        self.navigationItem.titleView = UIImageView(image:logo)
        
        self.postView.backgroundColor = UIColor.blackColor()
        self.footerActivityIndictor.startAnimating()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPageViewController" {
            if let indexPath = self.postView.indexPathForSelectedRow() {
                let post = redditPostArray[indexPath.row]
                
                let pageVC = segue.destinationViewController as! UIPageViewController
                pageVC.dataSource = self
                pageVC.delegate = self
                
                let logo = UIImage(named: "BlackLogo")
                pageVC.navigationItem.titleView = UIImageView(image:logo)
                
                let favoriteVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
                favoriteVC.detailPostIndexPosition = indexPath.row
                favoriteVC.detailPost = redditPostArray[indexPath.row]
                
                pageVC.setViewControllers([favoriteVC], direction: UIPageViewControllerNavigationDirection.Reverse, animated: true, completion: nil)
            }
        }
    }
    
    func connectReddit() {
        
        let urlPath: String = "http://www.reddit.com/r/aww/hot.json?after=\(afterValue)"
        var url = NSURL(string: urlPath)!
        var request = NSURLRequest(URL: url)
        self.isLoadingData = true
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse!
            , data: NSData!, error: NSError!) -> Void in
            
            self.isLoadingData = false
            let json = JSON(data: data)
            self.afterValue = json["data"]["after"].stringValue ?? ""
            
            let jsonPosts =  json["data"]["children"].arrayValue
            
            for jsonPost in jsonPosts {
                var author = jsonPost["data"]["author"].stringValue ?? ""
                var title = jsonPost["data"]["title"].stringValue ?? ""
                var numComments = jsonPost["data"]["num_comments"].intValue ?? 0
                var pointScore = jsonPost["data"]["score"].intValue ?? 0
                var url = jsonPost["data"]["url"].stringValue ?? ""
                let post = RedditPost(author: author, title: title, numComments: numComments, pointScore: pointScore, url: url)
                
                //filtering for bad URLs and appending posts below
                if ((url as NSString).containsString("/a/") == false && (url as NSString).containsString("gif") == false && (url as NSString).containsString("gallery") == false && (url as NSString).containsString("new") == false && (url as NSString).containsString("imgur") == true)  {
                    
                    self.redditPostArray.append(post)
                    
                }
                
                
                self.postView.reloadData()

            }
        }
        
    }
    
    
    // MARK: - UITableView data source
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.postView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        configureRedditCell(cell, atIndexPath: indexPath)
        
        
        //try to find a method to see if cell at a particular index is visible or not to the user
        //theory of asynchronous request not catching up to user-scroll only makes sense if issue occurs when user scrolls fast or perhaps when the internet is really slow...
        
        //        var viewablePathArray = postView.indexPathsForVisibleRows()
        //        var cellVisible = postView.visibleCells() as [PostCell]
        
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditPostArray.count
    
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.isLoadingData {
            return
        }
        
        let contentSize = postView.contentSize
        let contentOffset = postView.contentOffset
        
        if (contentOffset.y > contentSize.height - scrollView.bounds.size.height) {
            connectReddit()
          self.footerActivityIndictor.startAnimating()
        }
    }
    
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }
    
     func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return postView.frame.width
                
    }
    
    
    // MARK: - UIPageViewController data source
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let currentDetailVC = viewController as! DetailViewController
        let positionIndex = currentDetailVC.detailPostIndexPosition
        
        if positionIndex <= 0 {
            return nil;
        }
        
        let favoriteVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        favoriteVC.detailPostIndexPosition = positionIndex - 1
        favoriteVC.detailPost = redditPostArray[positionIndex - 1]
        
        
        return favoriteVC
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
                
        let currentDetailVC = viewController as! DetailViewController
        let positionIndex = currentDetailVC.detailPostIndexPosition
        
        let favoriteVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        favoriteVC.detailPostIndexPosition = positionIndex + 1
        
        if positionIndex < redditPostArray.count - 1 {
            favoriteVC.detailPost = redditPostArray[positionIndex + 1]
        } else {
            connectReddit()
            return nil
        }
        
        return favoriteVC
    }
    
    func configureRedditCell(cell: PostCell, atIndexPath indexPath: NSIndexPath) {
        
        //This function is called from the tableViewCellForRowAtIndexPath function in the ViewController class. Within the retrieveAndSetImage function we can determine if the post's image is missing data. If it is, we need to return something that tells the tableViewCellForRowAtIndexPath function not to create a cell.
        
        
        
        let post = redditPostArray[indexPath.row]
        
        
        
        
        cell.titleLabel.text = "  \(post.title)"
        
        
        
        
        //Setting loading image & activity indicator while image is still being set
        
        //augmenting Imgur URL to request smaller image and increase load times
        var str = post.url
        
        //        if (str.rangeOfString("photobucket", options: nil, range: nil, locale: nil) != nil) {
        //            self.missingImage = true
        //            println("tagged photobucket")
        //            //tagging photobucket as these images do not load
        //        }
        
        //Lower loading times by adding "l" at the end of the image URL
        var components = NSURLComponents(string: str)
        var filePath = components?.path
        let range = filePath?.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch)
        
        if let range = range {
            filePath = filePath!.substringToIndex(range.startIndex) + "l" + filePath!.substringFromIndex(range.startIndex)
        }
        
        components?.path = filePath
        var URL = components?.URL
        //        println("trying to bind \(URL)")
        
        var request = NSURLRequest(URL: URL!)
        
        if post.image == nil {
            
            cell.postImageView.image = UIImage(named: "loading")
            
            cell.activityIndicator.startAnimating()
            
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {[weak self] response, data, error in
                
                cell.activityIndicator.stopAnimating()
                
                if (error != nil) {
                    println("Errored when attempting to fetch \(URL)")
                    return
                }
                
                post.image = UIImage(data: data)
                
                cell.postImageView?.image = post.image
                
                self?.postView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
            
        } else {
            cell.postImageView?.image = post.image
        }
    }
}






