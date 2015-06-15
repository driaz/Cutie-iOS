//
//  SecondViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 12/12/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import UIKit
import Foundation


class DetailViewController: UIViewController, UITableViewDelegate {

    var detailPost: RedditPost?
    var index = 0

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var shareButtonBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setRedditPost()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func setRedditPost() {
        
        // set post image
        if let title = detailPost?.title {
            postTextLabel.text = title
        } else {
            postTextLabel.text = nil
        }
        
        // set post title
        if let image = detailPost?.image {
        
            let minWidth = min(self.view.bounds.size.width, image.size.width)
            imageViewHeightConstraint.constant = minWidth * image.size.height / image.size.width
            postImageView.image = image
        } else {
            postImageView.image = UIImage(named: "loading")
            activityIndicator.startAnimating()
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction func saveToFavorites(sender: AnyObject) {
        
        // append post to other favorite posts
        var posts = [RedditPost]()
        if let postsData = NSUserDefaults.standardUserDefaults().dataForKey("RedditPosts") {
            posts = NSKeyedUnarchiver.unarchiveObjectWithData(postsData) as! [RedditPost]
        }
        
        let alertController: UIAlertController;
        
        if !contains(posts, detailPost!) {
            
            posts.append(detailPost!)
            
            // generate filename for post image
            let filename = generateImageFilename()
            detailPost?.filename = filename
            
            // save post image to file system
            let url = documentsURL().URLByAppendingPathComponent(filename)
            let image = detailPost?.image
            let imageData = UIImageJPEGRepresentation(image, 0.75)
            imageData.writeToURL(url, atomically: true)
            
            // archive favorite posts
            let data = NSKeyedArchiver.archivedDataWithRootObject(posts)
            NSUserDefaults.standardUserDefaults().setObject(data, forKey: "RedditPosts")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            alertController = UIAlertController(title: "Success!", message: "Added to your favorites.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            
        } else {
            alertController = UIAlertController(title: nil, message: "This post is already added to your favorites.", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        }
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func shareIt(sender: AnyObject) {
        
        let textToShare = detailPost!.title
        var imageToShare = detailPost!.image!
        var itemsToShare = [textToShare, imageToShare]
        
        var activityVC: UIActivityViewController = UIActivityViewController(activityItems: itemsToShare, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll]
        
        self.presentViewController(activityVC, animated: true, completion: nil)
        
        
        //mail is completely fucked...crashes when I try to type...
        //need to combine imageArray and shareArray
        
    }
    
    // MARK: - Helpers
    
    func documentsURL() -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[0] as! NSURL
    }
    
    func generateImageFilename() -> String {
        return NSUUID().UUIDString.stringByAppendingPathExtension("jpg")!
    }
}
