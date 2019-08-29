//
//  DataService.swift
//  RNDM
//
//  Created by juger rash on 26.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class DataService {
    //Variables -:
    static let instance = DataService()
    private var thoughtListener : Firebase.ListenerRegistration!
    private var authListenerHandler : AuthStateDidChangeListenerHandle? // this just to be aware id the user logged in or not
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
        if selectedCategory == ThoughtCategory.popular.rawValue {
            thoughtListener = Firebase.Firestore.firestore().collection(THOUGHT_REF).order(by: NUM_LIKES, descending: true).addSnapshotListener { (documentSnapshot, error) in
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
        }else {
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
    }
    func increaseNumOfLikes(thought : Thought){
        //Method 1
        Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId).setData([NUM_LIKES : thought.numLikes + 1 ], merge: true)
        
        //Method 2
        Firestore.firestore().document("thoughts/\(thought.documentId!)").updateData([NUM_LIKES : thought.numLikes + 1])
        
    }
    
    func createUser(forEmail email : String ,andPassword password: String , andUserName username : String , handler : @escaping (_ createUserCompleted : Bool) -> ()){
        Auth.auth().createUser(withEmail: email, password: password) { (userData, error) in
            if let error = error {
                debugPrint("Error creating user : \(error.localizedDescription)")
            }
            
            let changeRequest = userData?.user.createProfileChangeRequest()
            changeRequest?.displayName = username
            changeRequest?.commitChanges(completion: { (error) in
                if let error = error {
                    debugPrint(error.localizedDescription)
                }
            })
            
            guard let userId = userData?.user.uid else { return }
            Firestore.firestore().collection(USERS_REF).document(userId).setData([
                USERNAME : username ,
                CREATED_DATE : FieldValue.serverTimestamp()
                ], completion: { (error) in
                    if let error = error {
                        debugPrint(error.localizedDescription)
                        handler(false)
                    }else {
                        handler(true)
                    }
            })
            
        }
    }
    
    func loginUser(forEmail email : String , andPassword password : String , handler : @escaping (_ loginCompleted : Bool) -> ()){
        Auth.auth().signIn(withEmail: email, password: password) { (authData, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                handler(false)
            }else {
                handler(true)
            }
        }
    }
    func setDidStateChangeListener(handler : @escaping (_ isUserLoggedin : Bool) -> ()) {
        authListenerHandler = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                handler(false)
            }else {
                handler(true)
            }
        })
    }
    
    func logoutUser(handler : @escaping (_ isUserLoggedout : Bool) -> ()){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            handler(true)
        }catch let signoutError as NSError {
            debugPrint("Error signing out : \(signoutError.localizedDescription)")
            handler(false)
        }
    }
    
    func removeThoughtListener(){
        if thoughtListener != nil {
        thoughtListener.remove()
        }
    }
    
}
