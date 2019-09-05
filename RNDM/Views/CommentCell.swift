//
//  CommentCell.swift
//  RNDM
//
//  Created by juger rash on 31.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

//Protocols -:
protocol CommentDelegate {
    func commentOptionsMenuTapped(comment : Comment)
}

class CommentCell: UITableViewCell {
    
    //Outlets -:
    @IBOutlet private weak var usernameLbl : UILabel!
    @IBOutlet private weak var timeStampLbl : UILabel!
    @IBOutlet private weak var commentLbl : UILabel!
    @IBOutlet private weak var optionsMenuImg : UIImageView!
    
    //Variables -:
    private var comment : Comment!
    private var delegate : CommentDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        optionsMenuImg.isUserInteractionEnabled = true
    }
    
    //Functions -:
    func configureCell(comment : Comment , delegate : CommentDelegate){
        optionsMenuImg.isHidden = true
        self.usernameLbl.text = comment.username
        self.commentLbl.text = comment.commentTxt
        self.delegate = delegate
        self.comment = comment
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d , hh:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        self.timeStampLbl.text = timestamp
        if comment.userId == DataService.instance.getCurrentUserId() {
            optionsMenuImg.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(optionsMenuTapped(_:)))
            optionsMenuImg.addGestureRecognizer(tap)
        }
    }
    @objc func optionsMenuTapped(_ gestureRecognizer : UITapGestureRecognizer) {
        delegate?.commentOptionsMenuTapped(comment: comment)
    }
}
