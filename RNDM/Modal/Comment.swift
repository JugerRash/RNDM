//
//  Comment.swift
//  RNDM
//
//  Created by juger rash on 31.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import Foundation

class Comment {
    private(set) var username : String!
    private(set) var timestamp : Date!
    private(set) var commentTxt : String!
    
    init(username : String , timestamp : Date , commentTxt : String) {
        self.username = username
        self.timestamp = timestamp
        self.commentTxt = commentTxt
    }

}
