//
//  RedditPost.swift
//  Aww2
//
//  Created by Daniel Riaz on 12/4/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import Foundation

class RedditPost: NSObject, Equatable, NSCoding {
    
    var author: String
    var title: String
    var numComments: Int
    var pointScore: Int
    var url: String
    var image: UIImage?
    var fittingHeight: CGFloat?
    var filename: String?
    
    init(author: String, title: String, numComments: Int, pointScore: Int, url: String) {
        self.author = author
        self.title = title
        self.numComments = numComments
        self.pointScore = pointScore
        
        self.url = url
        
        if ((url.lastPathComponent as NSString).containsString(".") == false) {
            self.url += ".jpeg"
        }
    }
    
    // MARK: - NSCoding
    
    @objc required init(coder aDecoder: NSCoder) {
        author = aDecoder.decodeObjectForKey("author") as! String
        title = aDecoder.decodeObjectForKey("title") as! String
        numComments = aDecoder.decodeIntegerForKey("num_comments")
        pointScore = aDecoder.decodeIntegerForKey("point_score")
        url = aDecoder.decodeObjectForKey("url") as! String
        fittingHeight = CGFloat(aDecoder.decodeFloatForKey("fitting_height"))
        filename = aDecoder.decodeObjectForKey("filename") as? String
    }
    
    @objc func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(author, forKey: "author")
        aCoder.encodeObject(title, forKey: "title")
        aCoder.encodeInteger(numComments, forKey: "num_comments")
        aCoder.encodeInteger(pointScore, forKey: "point_score")
        aCoder.encodeObject(url, forKey: "url")
        aCoder.encodeFloat(Float(fittingHeight!), forKey: "fitting_height")
        aCoder.encodeObject(filename, forKey: "filename")
    }
}

func ==(lhs: RedditPost, rhs: RedditPost) -> Bool {
    return lhs.author == rhs.author
}
    