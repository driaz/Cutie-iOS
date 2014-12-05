//
//  ViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 11/21/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import UIKit

class ViewController: UITableViewController, NSURLConnectionDelegate {
    
    var data = NSMutableData()
    var authorArray = [AnyObject]()
    var titleArray = [AnyObject]()
    var numCommentsArray = [AnyObject]()
    var pointScoreArray = [AnyObject]()
    var urlArray = [AnyObject]()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.connectReddit()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
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
        
        let listings =  json["data"]["children"]
        
            for var i = 0; i < listings.arrayValue!.count; i++ {
                var authorData = listings[i]["data"]["author"]
                var titleData = json["data"]["children"][i]["data"]["title"]
                var numCommentsData = json["data"]["children"][i]["data"]["num_comments"]
                var pointScoreData = json["data"]["children"][i]["data"]["score"]
                var urlData = json["data"]["children"][i]["data"]["url"]
                
                var listingCount = json["data"]["children"]
                
        
                authorArray.append(authorData.stringValue ?? "")
                titleArray.append(titleData.stringValue ?? "")
                numCommentsArray.append(numCommentsData.numberValue ?? "")
                pointScoreArray.append(pointScoreData.numberValue ?? "")
                urlArray.append(urlData.stringValue ?? "")
                
                }
        
        println(authorArray[2])
        println(titleArray[2])
        println(numCommentsArray[2])
        println(pointScoreArray[2])
        println(urlArray[2])
        

    }
    

}




