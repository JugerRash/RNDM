//
//  ThoughtCell.swift
//  RNDM
//
//  Created by juger rash on 26.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class ThoughtCell: UITableViewCell {

    //Outlets -:
    @IBOutlet private weak var usernameLbl : UILabel!
    @IBOutlet private weak var timestampLbl : UILabel!
    @IBOutlet private weak var thoughtLbl : UILabel!
    @IBOutlet private weak var likeImg : UIImageView!
    @IBOutlet private weak var likesNumberLbl : UILabel!
    //Variables -:
    private var thought : Thought!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likesImgTapped(_:)))
        likeImg.addGestureRecognizer(tap)
        likeImg.isUserInteractionEnabled = true
        
    }

    //Functions -:
    @objc func likesImgTapped(_ sender : UITapGestureRecognizer){
        DataService.instance.increaseNumOfLikes(thought: thought)
    }
    func configureCell(thought : Thought){
        self.thought = thought
        self.usernameLbl.text = thought.username
        self.thoughtLbl.text = thought.thoughtTxt
        self.likesNumberLbl.text = String(describing: thought.numLikes!)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d , hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        self.timestampLbl.text = timestamp
    }

}
