//
//  CommentsVC.swift
//  RNDM
//
//  Created by juger rash on 31.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class CommentsVC: UIViewController {
    
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
        addCommentView.bindtoKeyboard()
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
        cell.configureCell(comment: comments[indexPath.row])
        return cell
    }
}
