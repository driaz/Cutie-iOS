//
//  ViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 11/21/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerActivityIndictor: UIActivityIndicatorView!
    
    var isLoadingData = false
    var redditPostArray = [RedditPost]()
    var afterValue: String = String()
    var detailViewControllers = [DetailViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "BlackLogo")
        self.navigationItem.titleView = UIImageView(image:logo)
        
        self.tableView.backgroundColor = UIColor.blackColor()
        self.footerActivityIndictor.startAnimating()
        
        loadRedditPostsWithImages()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showPageViewController" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let post = redditPostArray[indexPath.row]
                
                let pageVC = segue.destinationViewController as! UIPageViewController
                pageVC.dataSource = self
                pageVC.delegate = self
                
                let logo = UIImage(named: "BlackLogo")
                pageVC.navigationItem.titleView = UIImageView(image:logo)
                
                let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
                detailVC.index = indexPath.row
                detailVC.detailPost = redditPostArray[indexPath.row]
                
                pageVC.setViewControllers([detailVC], direction: .Reverse, animated: true, completion: nil)
                
                detailViewControllers.append(detailVC)
            }
        }
    }
    
    // MARK: - Load posts
    
    func loadRedditPostsWithImages() {
        
        self.isLoadingData = true
        
        loadRedditPosts().continueWithSuccessBlock { (task) -> AnyObject! in
            
            let posts = task.result as! [RedditPost]
            
            var task = BFTask(result: nil)
            
            for post in posts {
                task = task.continueWithBlock { (task) -> AnyObject! in
                    return self.loadImageOfPost(post)
                }
            }
            
            task.continueWithBlock { (task) -> AnyObject! in
                self.isLoadingData = false
                return nil
            }
            
            return task
        }
    }
    
    
    func loadRedditPosts() -> BFTask! {
        
        let taskCompletionSource = BFTaskCompletionSource()
        
        let urlPath: String = "http://www.reddit.com/r/aww/hot.json?after=\(self.afterValue)"
        var url = NSURL(string: urlPath)
        var request = NSURLRequest(URL: url!)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { response, data, error in
            
            if error != nil {
                taskCompletionSource.setError(error)
                return;
            }
            
            let json = JSON(data: data)
            self.afterValue = json["data"]["after"].stringValue ?? ""
            let jsonPosts =  json["data"]["children"].arrayValue
            var redditPosts = [RedditPost]()
            
            for jsonPost in jsonPosts {
                var author = jsonPost["data"]["author"].stringValue ?? ""
                var title = jsonPost["data"]["title"].stringValue ?? ""
                var numComments = jsonPost["data"]["num_comments"].intValue ?? 0
                var pointScore = jsonPost["data"]["score"].intValue ?? 0
                var url = jsonPost["data"]["url"].stringValue ?? ""
                let post = RedditPost(author: author, title: title, numComments: numComments, pointScore: pointScore, url: url)
                
                //filtering for bad URLs and appending posts below
                if ((url as NSString).containsString("/a/") == false &&
                    (url as NSString).containsString("gif") == false &&
                    (url as NSString).containsString("gallery") == false &&
                    (url as NSString).containsString("new") == false &&
                    (url as NSString).containsString("imgur") == true)  {
                        
                        redditPosts.append(post)
                }
            }
            taskCompletionSource.setResult(redditPosts)
        }
        
        return taskCompletionSource.task
    }
    
    func loadImageOfPost(post: RedditPost) -> BFTask! {
        
        let taskCompletionSource = BFTaskCompletionSource()
        
        //Lower loading times by adding "l" at the end of the image URL
        var components = NSURLComponents(string: post.url)
        var filePath = components?.path
        let range = filePath?.rangeOfString(".", options: .BackwardsSearch)
        
        if let range = range {
            filePath = filePath!.substringToIndex(range.startIndex) + "l" + filePath!.substringFromIndex(range.startIndex)
        }
        
        components?.path = filePath
        var URL = components?.URL
        var request = NSURLRequest(URL: URL!)
        
        let manager = AFURLSessionManager()
        manager.responseSerializer = AFHTTPResponseSerializer()
        
        let downloadTask = manager.dataTaskWithRequest(request) { (_, data, error) -> Void in
            
            if error != nil {
                taskCompletionSource.setError(error)
                
            } else {
                if let image = UIImage(data: data as! NSData) {
                    post.image = image
                    let minWidth = min(self.view.bounds.size.width, image.size.width)
                    let minHeight = self.view.bounds.size.height - 20.0 - 44.0 - 49.0
                    post.fittingHeight = min(minHeight, minWidth * image.size.height / image.size.width)
                    self.redditPostArray.append(post)
                    self.tableView.reloadData()
                    if let pageVC = self.navigationController!.topViewController as? UIPageViewController {
                        // set post for current detail view controller on the page view controller
                        for detailVC in self.detailViewControllers {
                            if detailVC.index == self.redditPostArray.count - 1 {
                                self.configureDetailViewController(detailVC, withPost: post)
                            }
                        }
                    }
                }
                
                taskCompletionSource.setResult(nil)
            }
        }
        
        downloadTask.resume()
        
        return taskCompletionSource.task
    }
    
    // MARK: - UITableView data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return redditPostArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostCell
        
        configureRedditCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        let post = redditPostArray[indexPath.row]
        
        return post.fittingHeight ?? 320.0
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.isLoadingData {
            return
        }
        
        let contentSize = self.tableView.contentSize
        let contentOffset = self.tableView.contentOffset
        
        if (contentOffset.y > contentSize.height - scrollView.bounds.size.height) {
            loadRedditPostsWithImages()
            self.footerActivityIndictor.startAnimating()
        }
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
        if positionIndex < redditPostArray.count {
            let post = redditPostArray[positionIndex]
            configureDetailViewController(detailVC, withPost:post)
        }
        
        detailViewControllers.insert(detailVC, atIndex: 0)
        if detailViewControllers.count > 3 {
            detailViewControllers.removeLast()
        }
        
        return detailVC
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
                
        let currentDetailVC = viewController as! DetailViewController
        let positionIndex = currentDetailVC.index + 1
        let detailVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetailViewController") as! DetailViewController
        detailVC.index = positionIndex
        
        if positionIndex < redditPostArray.count {
            let post = redditPostArray[positionIndex]
            configureDetailViewController(detailVC, withPost:post)
            
        } else if !isLoadingData {
            loadRedditPostsWithImages()
        }
        
        detailViewControllers.append(detailVC)
        if detailViewControllers.count > 3 {
            detailViewControllers.removeAtIndex(0)
        }
        
        return detailVC
    }
    
    
    // MARK: -
    
    func configureDetailViewController(detailVC: DetailViewController, withPost post: RedditPost) {
        
        detailVC.detailPost = post
        if detailVC.isViewLoaded() {
            detailVC.setRedditPost()
            detailVC.activityIndicator.stopAnimating()
        }
    }
    
    func configureRedditCell(cell: PostCell, atIndexPath indexPath: NSIndexPath) {
        
        // This function is called from the tableView(_:cellForRowAtIndexPath:) function in the ViewController class.
        // Within the retrieveAndSetImage function we can determine if the post's image is missing data. If it is,
        // we need to return something that tells the tableViewCellForRowAtIndexPath function not to create a cell.
        
        let post = redditPostArray[indexPath.row]
        cell.titleLabel.text = "  \(post.title)"
        cell.postImageView.image = post.image
    }
}
