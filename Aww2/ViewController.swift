//
//  ViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 11/21/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, NSURLConnectionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    var data = NSMutableData()
    var redditPostArray = [RedditPost]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectReddit()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func connectReddit() {
        let urlPath: String = "http://www.reddit.com/r/aww/hot.json"
        var url = NSURL(string: urlPath)!
        var request = NSURLRequest(URL: url)
        var connection = NSURLConnection(request: request, delegate: self, startImmediately: false)!
        connection.start()
    }
    
    func connection(connection: NSURLConnection!, didReceiveData data: NSData!){
        self.data.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection!) {
        
        let json = JSON(data: data)
        if let jsonPosts =  json["data"]["children"].arrayValue {
    
        
            for jsonPost in jsonPosts {
                var author = jsonPost["data"]["author"].stringValue ?? ""
                var title = jsonPost["data"]["title"].stringValue ?? ""
                var numComments = jsonPost["data"]["num_comments"].integerValue ?? 0
                var pointScore = jsonPost["data"]["score"].integerValue ?? 0
                var url = jsonPost["data"]["url"].stringValue ?? ""
                let post = RedditPost(author: author, title: title, numComments: numComments, pointScore: pointScore, url: url)
                redditPostArray.append(post)
                
            }
            tableView.reloadData()
        }

    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("blah") as PostCell
        let post = redditPostArray[indexPath.row]
        cell.titleLabel.text = post.title
//        cell.titleLabel.sizeToFit()
        cell.authorLabel.text = "by \(post.author)"
        
//        var postURL: NSURL = NSURL(string: post.url)!
//        var data2: NSData = NSData(contentsOfURL: postURL)!
//        cell.listingImageView.image = UIImage(data: data2)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> () in
            
            var postURL: NSURL = NSURL(string: post.url)!
            var data2: NSData = NSData(contentsOfURL: postURL)!
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.listingImageView.image = UIImage(data: data2)
            })
        })
        
        return cell
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        tableView.reloadData()
        
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println(redditPostArray.count)
        return redditPostArray.count
    
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
       return 1
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension;
    }

    
    
}




