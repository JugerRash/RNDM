//
//  Thought.swift
//  
//
//  Created by juger rash on 26.08.19.
//

import Foundation

class Thought {
    //Variables -:
    private(set) var username : String!
    private(set) var timestamp : Date!
    private(set) var thoughtTxt : String!
    private(set) var numLikes : Int!
    private(set) var numComments : Int!
    private(set) var documentId : String!
    private(set) var userId : String!
    
    init(username : String , timestamp : Date , thoughtTxt : String , numLikes : Int , numComments : Int , documentId : String, userId : String) {
        self.username = username
        self.timestamp = timestamp
        self.thoughtTxt = thoughtTxt
        self.numLikes = numLikes
        self.numComments = numComments
        self.documentId = documentId
        self.userId = userId
    }
    
}
