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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //Functions -:
    func configureCell(thought : Thought){
        self.usernameLbl.text = thought.username
        self.thoughtLbl.text = thought.thoughtTxt
        self.likesNumberLbl.text = String(describing: thought.numLikes!)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d , hh:mm"
        let timestamp = formatter.string(from: thought.timestamp)
        self.timestampLbl.text = timestamp
    }

}
