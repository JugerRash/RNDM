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
    private var commentsListener : Firebase.ListenerRegistration!
    private var authListenerHandler : AuthStateDidChangeListenerHandle? // this just to be aware id the user logged in or not
    private var thoughtRef : DocumentReference!
    //Functions -:
    func addCollection(thoughtTxt : String , selectedCategory : String , handler : @escaping (_ addCollectionCompleted : Bool ) -> ()){
        Firebase.Firestore.firestore().collection(THOUGHT_REF).addDocument(data: [
            CATEGORY_THOUGHT : selectedCategory,
            NUM_COMMENTS : 0,
            NUM_LIKES : 0,
            THOUGHT_TXT : thoughtTxt,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : self.getCurrentUsername() ?? "",
            USER_ID : self.getCurrentUserId()!
            ] , completion: { (error) in
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
                        let userId = data[USER_ID] as? String ?? ""
                        
                        let thought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId, userId: userId)
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
                    let userId = data[USER_ID] as? String ?? ""
                    
                    let thought = Thought(username: username, timestamp: timestamp, thoughtTxt: thoughtTxt, numLikes: numLikes, numComments: numComments, documentId: documentId, userId: userId)
                    thoughtsArray.append(thought)
                }
                handler(thoughtsArray)
        }
        }
    }
    }
    func getAllComments(thought : Thought,handler : @escaping (_ returnedCommentsArray : [Comment]) -> ()){
        commentsListener = Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId).collection(COMMENTS_REF).order(by: TIMESTAMP, descending: false).addSnapshotListener({ (documentSnapshot, error) in
            if error != nil {
                debugPrint("Could not fetch all the comments : \(error!.localizedDescription)")
                handler([Comment]())
            }else {
                guard let snap = documentSnapshot else { return }
                var commentsArray = [Comment]()
                for document in snap.documents {
                    let data = document.data()
                    let username = data[USERNAME] as? String ?? "Anonymous"
                    let timestamp = data[TIMESTAMP] as? Date ?? Date()
                    let commentTxt = data[COMMENT_TXT] as? String ?? ""
                    let documentId = document.documentID
                    let userId = data[USER_ID] as? String ?? "" 
                    let newComment = Comment(username: username, timestamp: timestamp, commentTxt: commentTxt, documentId: documentId, userId: userId)
                    commentsArray.append(newComment)
                }
                handler(commentsArray)
            }
        })
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
    func removeCommentListener(){
        if commentsListener != nil {
            commentsListener.remove()
        }
    }
    func addNewComment(thought : Thought, username : String , commentTxt : String ,handler : @escaping (_ addNewCommentCompleted : Bool) -> ()){
        //we will use transaction cuz we need to write and read multiple things so we have to use transaction and u have to be careful the transaction will fail if the user is offline and u have to read first and then write :)
        thoughtRef = Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId)
        Firestore.firestore().runTransaction({ (transaction, error) -> Any? in
            let thoughtDocument : DocumentSnapshot
            do {
                try thoughtDocument = transaction.getDocument(Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId))
            } catch let error as NSError{
                debugPrint(error.localizedDescription)
                handler(false)
                return nil
            }
            guard let oldNumberComment = thoughtDocument.data()![NUM_COMMENTS] as? Int else {
                return nil
            }
            transaction.updateData([NUM_COMMENTS : oldNumberComment + 1 ], forDocument: self.thoughtRef)
            let newCommentRef = Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId).collection(COMMENTS_REF).document()//create new document with auto id
            transaction.setData([COMMENT_TXT : commentTxt ,
                                 TIMESTAMP : FieldValue.serverTimestamp() ,
                                 USERNAME : username,
                                 USER_ID : self.getCurrentUserId()!
                                 ], forDocument: newCommentRef)
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                handler(false)
            }else {
                handler(true)
            }
        }
        
    }
    func deleteComment(thought : Thought , comment : Comment , handler : @escaping (_ isDeleteCompleted : Bool) -> ()){
            //we can use the following code to delete a document but there is a problem cuz we need to modify the number of comments in our database in firestore
//        Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId).collection(COMMENTS_REF).document(comment.documentId).delete { (error) in
//            if let error = error {
//                debugPrint("Could not delete the comment :\(error)")
//                handler(false)
//            }else {
//                print("Successfully comment deleted :) ")
//                handler(true)
//            }
//        }
        
        //so cuz we need to delete and modify the number of comments in our database we have to use the transaction
        thoughtRef = Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId)
        Firestore.firestore().runTransaction({ (transaction, error) -> Any? in
            let thoughtDocument : DocumentSnapshot
            do {
                try thoughtDocument = transaction.getDocument(Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId))
            } catch let error as NSError{
                debugPrint(error.localizedDescription)
                handler(false)
                return nil
            }
            guard let oldNumberComment = thoughtDocument.data()![NUM_COMMENTS] as? Int else {
                return nil
            }
            transaction.updateData([NUM_COMMENTS : oldNumberComment - 1 ], forDocument: self.thoughtRef)
            let oldCommentRef = Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId).collection(COMMENTS_REF).document(comment.documentId)
            transaction.deleteDocument(oldCommentRef)
            return nil
        }) { (object, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
                handler(false)
            }else {
                handler(true)
            }
        }
    }
    func editingComment(thought : Thought , comment : Comment ,newCommentTxt : String , handler : @escaping (_ editingCompleted : Bool) -> () ){
        Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId).collection(COMMENTS_REF).document(comment.documentId).updateData([COMMENT_TXT : newCommentTxt]) { (error) in
            if error != nil {
                debugPrint("Could not editing comment : \(error!.localizedDescription)")
                handler(false)
            }else {
                handler(true)
            }
        }
    }
    func deleteThought(thought : Thought , handler : @escaping (_ deleteCompleted : Bool) -> ()){
        let subCollectionRef = Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId).collection(COMMENTS_REF)
        delete(collection: subCollectionRef) { (error) in
            if let error = error {
                debugPrint("Could not delete subCollections : \(error.localizedDescription)")
                handler(false)
            } else {
                Firestore.firestore().collection(THOUGHT_REF).document(thought.documentId).delete(completion: { (error) in
                    if let error = error {
                        debugPrint("Could not delete thought : \(error.localizedDescription)")
                        handler(false)
                    }else {
                        handler(true)
                    }
                })
            }
        }
    }
    func delete(collection: CollectionReference, batchSize: Int = 100, completion: @escaping (Error?) -> ()) {
        // Limit query to avoid out-of-memory errors on large collections.
        // When deleting a collection guaranteed to fit in memory, batching can be avoided entirely.
        collection.limit(to: batchSize).getDocuments { (docset, error) in
            // An error occurred.
            guard let docset = docset else {
                completion(error)
                return
            }
            // There's nothing to delete.
            guard docset.count > 0 else {
                completion(nil)
                return
            }
            
            let batch = collection.firestore.batch()
            docset.documents.forEach { batch.deleteDocument($0.reference) }
            
            batch.commit { (batchError) in
                if let batchError = batchError {
                    // Stop the deletion process and handle the error. Some elements
                    // may have been deleted.
                    completion(batchError)
                } else {
                    self.delete(collection: collection, batchSize: batchSize, completion: completion)
                }
            }
        }
    }
    func getCurrentUsername() -> String?{
        return Auth.auth().currentUser?.displayName ?? nil
    }
    func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid ?? ""
    }
}
