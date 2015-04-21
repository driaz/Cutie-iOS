//
//  ViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 11/21/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITraitEnvironment {
    
    @IBOutlet var postView: UITableView!
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var footerActivityIndictor: UIActivityIndicatorView!
    @IBOutlet weak var footerLabel: UILabel!
    
    var isLoadingData = false
    var redditPostArray = [RedditPost]()
    var afterValue: String = String()
    var pageViewController = UIPageViewController()
//    internal var currentIndexPath: NSIndexPath? = NSIndexPath()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectReddit()
        
        let logo = UIImage(named: "BlackLogo")
        let imageView = UIImageView(image:logo)
        self.navItem.titleView = imageView
        self.postView.backgroundColor = UIColor.blackColor()
        self.footerActivityIndictor.startAnimating()
        
//        if  (currentIndexPath != nil) {
////            postView.scrollToRowAtIndexPath(currentIndexPath, atScrollPosition: UITableViewScrollPosition(), animated: false)
//        }
    
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
    

     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = self.postView.dequeueReusableCellWithIdentifier("CatCell") as! PostCell
        var post = redditPostArray[indexPath.row]
        cell.selectionStyle = .None
        cell.configureWithRedditPost(post)
 
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Instantiates PageViewController and calls getSecondViewController
        
        let selectedPostPosition = redditPostArray[indexPath.row]
        let indexPositionAsInt = find(redditPostArray, selectedPostPosition)
        
        if (indexPositionAsInt == redditPostArray.count-1){
            connectReddit()
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let pageController = storyboard.instantiateViewControllerWithIdentifier("PageViewController") as! UIPageViewController
        pageController.dataSource = self
        
        
        let firstController = getSecondViewController(indexPositionAsInt!)
        firstController.svcIndexPath = indexPath
        
        let startingViewControllers: NSArray = [firstController]
        
        pageController.setViewControllers(startingViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        
        pageController.hidesBottomBarWhenPushed = true
        //Now the image loads fine but the label and buttons get pushed down
        

//        self.showViewController(pageController, sender: nil)

        self.navigationController?.pushViewController(pageController, animated: true)
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }
    
    func getSecondViewController(itemIndex: Int) -> SecondViewController {
        
        //Instantiates SVC and passes relevant properties
        
        let tappedPost = redditPostArray[itemIndex]
        let secondViewController = storyboard?.instantiateViewControllerWithIdentifier("SecondViewController") as! SecondViewController
        
        secondViewController.detailPost = tappedPost
        secondViewController.detailPostIndexPosition = itemIndex
        secondViewController.hidesBottomBarWhenPushed = true

        return secondViewController
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! SecondViewController
        
        if itemController.detailPostIndexPosition > 0 {
            return getSecondViewController(itemController.detailPostIndexPosition-1)
        }
        
        return nil

    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
                
        let itemController = viewController as! SecondViewController
        

        if (itemController.detailPostIndexPosition == redditPostArray.count-1){
            println("the redditpost position IS \(itemController.detailPostIndexPosition)")
            connectReddit()

        }
        
        if (itemController.detailPostIndexPosition < redditPostArray.count-1) {
            println("the redditpostarray count is \(redditPostArray.count)")
            println("the redditpost position is \(itemController.detailPostIndexPosition)")
            
                if (itemController.detailPostIndexPosition == redditPostArray.count-2) {
                connectReddit()
                println("the redditpostarray count NOW is \(redditPostArray.count)")

                
                }
            
            return getSecondViewController(itemController.detailPostIndexPosition+1)
        }
        
      
        
        return nil
    }
    

}







