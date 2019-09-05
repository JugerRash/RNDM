//
//  CommentsVC.swift
//  RNDM
//
//  Created by juger rash on 31.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController , CommentDelegate {

    //Outlets -:
    @IBOutlet private weak var tableView : UITableView!
    @IBOutlet private weak var commentTxtField : UITextField!
    @IBOutlet private weak var addCommentBtn : UIButton!
    @IBOutlet private weak var addCommentView : UIView!
    
    //Variables -:
    var thought : Thought!
    var comments = [Comment]()
    var username : String!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if let name = DataService.instance.getCurrentUsername() {
            username = name
        }
        addCommentView.bindToKeyboard()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllComments(thought: thought) { (returnedCommentsArray) in
            self.comments = returnedCommentsArray
            self.tableView.reloadData()
        }
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DataService.instance.removeCommentListener()
    }
    //Actions -:
    @IBAction func addCommentBtnPressed(_ sender : Any ){
        guard let commentTxt = commentTxtField.text else { return }
        DataService.instance.addNewComment(thought : thought ,username : username, commentTxt: commentTxt) { (success) in
            if success {
                self.commentTxtField.text = ""
                self.commentTxtField.resignFirstResponder()
            }
        }
    }
    //Functions -:
    func commentOptionsMenuTapped(comment: Comment) {
        let alert = UIAlertController(title: "Delete Comment", message: "You can delete comment and edit comment ", preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "Edit Comment", style: .default) { (action) in
            self.performSegue(withIdentifier: TO_EDIT_COMMENT, sender: (comment , self.thought))
        }
        let deleteAction = UIAlertAction(title: "Delete Comment", style: .default) { (action) in
            DataService.instance.deleteComment(thought: self.thought, comment: comment, handler: { (success) in
                if success {
                 alert.dismiss(animated: true, completion: nil)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? UpdateCommentVC {
            if let data = sender as? (comment : Comment , thought : Thought) {
                destinationVC.documentData = data
            }
        }
    }
}

extension CommentsVC : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: COMMENT_CELL, for: indexPath) as? CommentCell else { return UITableViewCell() }
        cell.configureCell(comment: comments[indexPath.row], delegate: self)
        return cell
    }
}
