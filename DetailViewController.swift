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
    var detailPostIndexPosition = Int()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    
    
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
            postImageView.image = image
        } else {
            activityIndicator.startAnimating()
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - IB Actions
    
    @IBAction func saveToFavorites(sender: AnyObject) {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.appDelegateFavorites.append(detailPost!)
        
        let alertController = UIAlertController(title: "Success!", message: "Added to your favorites.", preferredStyle: UIAlertControllerStyle.Alert)
        
        self.presentViewController(alertController, animated: true, completion: nil)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        
    }
    
    @IBAction func shareIt(sender: AnyObject) {
        
        var shareText = detailPost?.title as String!
        var postURL: NSURL = NSURL(string: self.detailPost!.url)!
        var data: NSData = NSData(contentsOfURL: postURL)!
        var imageToShare = UIImage(data: data)!
        var shareArray = [shareText]
        var imageArray = [imageToShare]
        
        var activityVC: UIActivityViewController = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
        
        activityVC.excludedActivityTypes = [UIActivityTypePrint, UIActivityTypePostToFlickr, UIActivityTypePostToTencentWeibo, UIActivityTypePostToVimeo, UIActivityTypeAddToReadingList, UIActivityTypeAssignToContact, UIActivityTypeCopyToPasteboard, UIActivityTypeSaveToCameraRoll]
        
        self.presentViewController(activityVC, animated: true, completion: nil)
        
        
        //mail is completely fucked...crashes when I try to type...
        //need to combine imageArray and shareArray
        
    }
}
