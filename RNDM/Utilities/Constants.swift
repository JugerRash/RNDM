//
//  Constants.swift
//  RNDM
//
//  Created by juger rash on 25.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit


//Enums -:
enum ThoughtCategory : String {
    case funny = "funny"
    case serious = "serious"
    case crazy = "crazy"
    case popular = "popular"
}

//Document Dicitionary
let THOUGHT_REF = "thoughts"
let COMMENTS_REF = "comments"

let CATEGORY_THOUGHT = "categoryThought"
let NUM_COMMENTS = "numComments"
let NUM_LIKES = "numLikes"
let THOUGHT_TXT = "thoughtTxt"
let TIMESTAMP = "timeStamp"
let USERNAME = "username"
let COMMENT_TXT = "commentTxt"
let USER_ID = "userId"

// Cells -:
let THOUGHT_CELL = "thoughtCell"
let COMMENT_CELL = "commentCell"

//User collections -:
let USERS_REF = "users"
let CREATED_DATE = "createdDate"

//Storyboards Identifiers -:
let LOGIN_VC = "LoginVC"
let COMMENTS_VC = "CommentsVC"
//Segues Identifier -: 
let TO_COMMENTS_SEGUE = "toComments"
let TO_EDIT_COMMENT = "toEditComment"
