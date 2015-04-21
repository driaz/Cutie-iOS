//
//  PostCell.swift
//  Aww2
//
//  Created by Daniel Riaz on 12/8/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {
    
    var missingImage: Bool = false
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var listingImageView: UIImageView!
//    @IBOutlet weak var authorLabel: UILabel!
    weak var representedPost : RedditPost!
//    var heightOnWidth: CGFloat = CGFloat()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    func configureWithRedditPost(post: RedditPost) {
        
        //This function is called from the tableViewCellForRowAtIndexPath function in the ViewController class. Within the retrieveAndSetImage function we can determine if the post's image is missing data. If it is, we need to return something that tells the tableViewCellForRowAtIndexPath function not to create a cell.
        
        self.representedPost = post
        
        self.titleLabel.text = "  \(post.title)"

        self.retrieveAndSetImage()
        
        return
        
    }
    
    override func prepareForReuse() {
        self.listingImageView.image = UIImage(named: "loading")
        

    }
    
    func retrieveAndSetImage() {
        
        self.activityIndicator.startAnimating()
        self.listingImageView.image = UIImage(named: "loading")
        //Setting loading image & activity indicator while image is still being set
        
        //augmenting Imgur URL to request smaller image and increase load times
        var str = self.representedPost.url
        
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
        
        var request = NSMutableURLRequest(URL: URL!)
        request.HTTPMethod = "GET"
        request.setValue("image/jpeg", forHTTPHeaderField: "Accept")
    
        let representedPostAtTimeOfImageRequest = self.representedPost
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {[weak self] response, data, error in
            
            if self?.representedPost != representedPostAtTimeOfImageRequest {
                // Post bound to this cell has changed.
                return;
            }
            
            if (error != nil) {
                println("Errored when attempting to fetch \(URL)")
                return
            }
            
            var image = UIImage(data: data)
            
            
            if let image = image {
                self?.listingImageView.image = image
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.hidesWhenStopped = true
//                self?.heightOnWidth = (image.size.height)/(image.size.width)

            }
                
            else {
                
                self?.missingImage = true
                println("this Reddit Post is missing an image")
                println(str)
                //tagging a bad image
                
            }
            
            println("image is downloaded")
            
        }
        
    }

}
