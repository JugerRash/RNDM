//
//  UpdateCommentVC.swift
//  RNDM
//
//  Created by juger rash on 02.09.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class UpdateCommentVC: UIViewController {

    //Outlets -:
    @IBOutlet private weak var commentTxtView : UITextView!
    @IBOutlet private weak var updateBtn : UIButton!
    
    //Variables -:
    var documentData : (comment : Comment , thought : Thought)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        commentTxtView.text = documentData.comment.commentTxt
    }
    //Actions -:
    @IBAction func updateBtnPressed(_ sender : Any) {
        DataService.instance.editingComment(thought: documentData.thought, comment: documentData.comment, newCommentTxt: commentTxtView.text) { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    //Functions -:
    func updateViews(){
        commentTxtView.layer.cornerRadius = 10
        updateBtn.layer.cornerRadius = 10
    }
}
