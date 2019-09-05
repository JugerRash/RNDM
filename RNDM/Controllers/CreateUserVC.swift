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
        guard let email = emailTxtField.text ,
              let password = passwordTxtField.text ,
            let username = usernameTxtField.text else { return }
        DataService.instance.createUser(forEmail: email, andPassword: password, andUserName: username) { (success) in
            if success {
             self.dismiss(animated: true, completion: nil)
            }
        }
    }
    @IBAction func cancelBtnPressed(_ sender : Any) {
        dismiss(animated: true, completion: nil)
    }
}
