//
//  RedditPost.swift
//  Aww2
//
//  Created by Daniel Riaz on 12/4/14.
//  Copyright (c) 2014 Daniel Riaz. All rights reserved.
//

import Foundation

class RedditPost {
    
    var author: String
    var title: String
    var numComments: Int
    var pointScore: Int
    var url: String
//    var data = NSMutableData()

    
    init(author: String, title: String, numComments: Int, pointScore: Int, url: String) {
        self.author = author
        self.title = title
        self.numComments = numComments
        self.pointScore = pointScore
        self.url = url
    }
}
    
    