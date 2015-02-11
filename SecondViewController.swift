//
//  SecondViewController.swift
//  Aww2
//
//  Created by Daniel Riaz on 12/12/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import UIKit
import Foundation

class SecondViewController: UIViewController, UITableViewDelegate {

    var detailPost: RedditPost?
    var favoriteArray = [RedditPost]()
    var inboundArrayFromVC = [RedditPost]()
    // passing in redditPostArray from ViewController to SecondViewController class  and storing it here
    
    var detailPostIndexPosition = Int()

    @IBOutlet weak var SVCImageView: UIImageView!
    
    @IBOutlet weak var SVCTextLabel: UILabel!
        
    @IBOutlet weak var SVCAuthorLabel: UILabel!
    
    @IBAction func saveToFavorites(sender: AnyObject) {
       
        favoriteArray.append(detailPost!)
        
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
    
//        @IBAction func swipe(sender: AnyObject) {
//            
//        println("Swiping")
//        println(detailPostIndexPosition)
//        detailPostIndexPosition++
//        SVCAuthorLabel.text = "by \(inboundArrayFromVC[detailPostIndexPosition].author)"
//        SVCTextLabel.text = inboundArrayFromVC[detailPostIndexPosition].title
//        var SVCImageViewUrl: String = inboundArrayFromVC[detailPostIndexPosition].url
//        var imageURL: NSURL = NSURL(string: SVCImageViewUrl)!
//        var imageData: NSData = NSData(contentsOfURL: imageURL)!
//        var theImage = UIImage(data: imageData)
//        SVCImageView.image = theImage
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        self.SVCTextLabel.text = detailPost?.title
        self.SVCAuthorLabel.text = "by \(detailPost!.author)"
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), { () -> () in
            
            var postURL: NSURL = NSURL(string: self.detailPost!.url)!

            let dataOptional = NSData(contentsOfURL: postURL)
            if let data = dataOptional {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.SVCImageView.image = UIImage(data: data)
                })
            }
            
        })

        
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
