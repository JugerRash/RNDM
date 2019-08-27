//
//  LoginVC.swift
//  RNDM
//
//  Created by juger rash on 27.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    //Outlet -:
    @IBOutlet private weak var emailTxtField: UITextField!
    @IBOutlet private weak var passwordTxtField : UITextField!
    @IBOutlet private weak var loginBtn : UIButton!
    @IBOutlet private weak var signupBtn : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signupBtn.layer.cornerRadius = 10
        loginBtn.layer.cornerRadius = 10
    }
    //Actions -:
    @IBAction func loginBtnPressed(_ sender : Any) {
        
    }
    @IBAction func signupBtnPressed(_ sender : Any) {
        
    }
}
