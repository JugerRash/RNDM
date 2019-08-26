//
//  DataService.swift
//  RNDM
//
//  Created by juger rash on 26.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import Foundation
import Firebase

class DataService {
    //Variables -:
    static let instance = DataService()
    private var thoughtListener : Firebase.ListenerRegistration!
    //Functions -:
    func addCollection(username : String , thoughtTxt : String , selectedCategory : String , handler : @escaping (_ addCollectionCompleted : Bool ) -> ()){
     
        
        Firebase.Firestore.firestore().collection(THOUGHT_REF).addDocument(data: [
            CATEGORY_THOUGHT : selectedCategory,
            NUM_COMMENTS : 0,
            NUM_LIKES : 0,
            THOUGHT_TXT : thoughtTxt,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : username] , completion: { (error) in
                if let error = error {
                    handler(false)
                    debugPrint("Adding document Faild cuz \(error)")
                }else {
                    handler(true)
                }
        })

    }
    func getAllDocuments(selectedCategory : String ,handler : @escaping (_ returnedThoughtsArray : [Thought]) -> ()) {
           //instead of getting all documents just i will add alistener to our data base in firestore it's better to make sure everything is updating with the realtime changes , but u have to remove the listener after u finish
        
        
//        Firebase.Firestore.firestore().collection(THOUGHT_REF).getDocuments { (documentSnapshot, error) in
//            if let error = error {
//                debugPrint("Error could not fetch all the documents \(error)")
//                handler([Thought]())
//            }else {
//                guard let snap = documentSnapshot else { return }
//                var thoughtsArray = [Thought]()
//                for document in snap.documents {
//                    let data = document.data()
//                    let username = data[USERNAME] as? String ?? "Anonymous"
//                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
//                    let thoughtTxt = data[THOUGHT_TXT] as? String ?? ""
//                    let numComments = data[NUM_COMMENTS] as? Int ?? 0
//                    let numLikes = data[NUM_LIKES] as? Int ?? 0
//                    let documentId = document.documentID
//
//                    let thought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId)
//                    thoughtsArray.append(thought)
//                }
//                handler(thoughtsArray)
//            }
//        }
      thoughtListener = Firebase.Firestore.firestore().collection(THOUGHT_REF).order(by: TIMESTAMP, descending: true).whereField(CATEGORY_THOUGHT, isEqualTo: selectedCategory).addSnapshotListener { (documentSnapshot, error) in
            if let error = error {
                debugPrint("Error could not fetch all the documents \(error)")
                handler([Thought]())
            }else {
                guard let snap = documentSnapshot else { return }
                var thoughtsArray = [Thought]()
                for document in snap.documents {
                    let data = document.data()
                    let username = data[USERNAME] as? String ?? "Anonymous"
                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
                    let thoughtTxt = data[THOUGHT_TXT] as? String ?? ""
                    let numComments = data[NUM_COMMENTS] as? Int ?? 0
                    let numLikes = data[NUM_LIKES] as? Int ?? 0
                    let documentId = document.documentID
                    
                    let thought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId)
                    thoughtsArray.append(thought)
                }
                handler(thoughtsArray)
        }
        }
    }
    func removeThoughtListener(){
        thoughtListener.remove()
    }
    
}
