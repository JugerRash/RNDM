//
//  ThoughtCell.swift
//  RNDM
//
//  Created by juger rash on 26.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

protocol ThoughtDelegate {
    func thoughtOptionsMenuTapped(thought : Thought)
}

class ThoughtCell: UITableViewCell {

    //Outlets -:
    @IBOutlet private weak var usernameLbl : UILabel!
    @IBOutlet private weak var timestampLbl : UILabel!
    @IBOutlet private weak var thoughtLbl : UILabel!
    @IBOutlet private weak var likeImg : UIImageView!
    @IBOutlet private weak var likesNumberLbl : UILabel!
    @IBOutlet private weak var commentsImg : UIImageView!
    @IBOutlet private weak var commentsNumberLbl : UILabel!
    @IBOutlet private weak var optionsMenuImg : UIImageView!
    
    //Variables -:
    private var thought : Thought!
    private var delegate : ThoughtDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likesImgTapped(_:)))
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        optionsMenuImg.isUserInteractionEnabled = true
    }

    //Functions -:
    @objc func likesImgTapped(_ sender : UITapGestureRecognizer){
        DataService.instance.increaseNumOfLikes(thought: thought)
    }
    func configureCell(thought : Thought , delegate : ThoughtDelegate){
        self.thought = thought
        optionsMenuImg.isHidden = true
        self.delegate = delegate
        self.usernameLbl.text = thought.username
        self.thoughtLbl.text = thought.thoughtTxt
        self.likesNumberLbl.text = String(describing: thought.numLikes!)
        self.commentsNumberLbl.text = String(describing: thought.numComments!)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d , hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        self.timestampLbl.text = timestamp
        
        if thought.userId == DataService.instance.getCurrentUserId() {
            optionsMenuImg.isHidden = false
            let tap = UITapGestureRecognizer(target: self, action: #selector(thoughtOptionsMenuTapped(_:)))
            optionsMenuImg.addGestureRecognizer(tap)
        }
    }
    @objc func thoughtOptionsMenuTapped(_ gestureRecognizer : UITapGestureRecognizer){
        delegate?.thoughtOptionsMenuTapped(thought: thought)
    }
}
