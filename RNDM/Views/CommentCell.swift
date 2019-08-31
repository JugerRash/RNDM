//
//  CommentCell.swift
//  RNDM
//
//  Created by juger rash on 31.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    
    //Outlets -:
    @IBOutlet private weak var usernameLbl : UILabel!
    @IBOutlet private weak var timeStampLbl : UILabel!
    @IBOutlet private weak var commentLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //Functions -:
    func configureCell(comment : Comment){
        self.usernameLbl.text = comment.username
        self.commentLbl.text = comment.commentTxt
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d , hh:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        self.timeStampLbl.text = timestamp
        
    }
}
