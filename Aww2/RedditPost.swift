//
//  RedditPost.swift
//  Aww2
//
//  Created by Daniel Riaz on 12/4/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import Foundation

class RedditPost: Equatable {
    
    var author: String
    var title: String
    var numComments: Int
    var pointScore: Int
    var url: String
    var image: UIImage?
    var fittingHeight: CGFloat?

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
}

func ==(lhs: RedditPost, rhs: RedditPost) -> Bool {
    
    return lhs.author == rhs.author
    
}

//Conforming to Equatable Protocol so I can use find function for redditPostArray

let value1 = RedditPost(author: "test", title: "test", numComments: 1, pointScore: 1, url: "www.test.com")
let value2 = RedditPost(author: "test", title: "test", numComments: 1, pointScore: 1, url: "www.test.com")

let firstCheck = value1 == value2

    