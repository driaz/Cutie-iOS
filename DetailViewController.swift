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
    //var svcIndexPath: NSIndexPath? = NSIndexPath()

    @IBOutlet weak var SVCActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var SVCImageView: UIImageView!
    @IBOutlet weak var SVCTextLabel: UILabel!
    @IBOutlet weak var navItem: UINavigationItem!
    
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
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
//        let logo = UIImage(named: "BlackLogo")
//        let imageView = UIImageView(image:logo)
//        self.navItem.titleView = imageView
        self.navItem.title = "Hope!"
        self.navigationController?.navigationItem.title = "testing"
        


    
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.SVCTextLabel.text = detailPost?.title
        self.SVCImageView.image = UIImage(named: "loading")
        self.SVCActivityIndicator.startAnimating()
//        self.SVCAuthorLabel.text = "by \(detailPost!.author)"
    
        var str = self.detailPost!.url
        
        //Lower loading times by adding "l" at the end of the image URL
        var components = NSURLComponents(string: str)
        var filePath = components?.path
        let range = filePath?.rangeOfString(".", options: NSStringCompareOptions.BackwardsSearch)
        
        if let range = range {
            filePath = filePath!.substringToIndex(range.startIndex) + "l" + filePath!.substringFromIndex(range.startIndex)
        }
    
        
        components?.path = filePath
        var URL = components?.URL
        
        var request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        request.setValue("image/jpeg", forHTTPHeaderField: "Accept")
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {[weak self] response, data, error in
            
            if (error != nil) {
                println("Errored when attempting to fetch \(URL)")
                return
            }
            
            var image = UIImage(data: data)
            
            if (image != nil){
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self?.SVCImageView.image = image!
                self?.SVCActivityIndicator.stopAnimating()
                self?.SVCActivityIndicator.hidesWhenStopped = true
            })
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
