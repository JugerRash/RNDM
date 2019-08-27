//
//  CreateUserVC.swift
//  RNDM
//
//  Created by juger rash on 27.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class CreateUserVC: UIViewController {

    //Outlets -:
    @IBOutlet private weak var emailTxtField : UITextField!
    @IBOutlet private weak var passwordTxtField : UITextField!
    @IBOutlet private weak var usernameTxtField : UITextField!
    @IBOutlet private weak var createUserBtn : UIButton!
    @IBOutlet private weak var cancelBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createUserBtn.layer.cornerRadius = 10
        cancelBtn.layer.cornerRadius = 10
    }
    //Actions -:
    @IBAction func createUserBtnPressed(_ sender : Any ){
        
    }
    @IBAction func cancelBtnPressed(_ sender : Any) {
        
    }
}
