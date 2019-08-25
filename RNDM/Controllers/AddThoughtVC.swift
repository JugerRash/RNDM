//
//  AddThoughtVC.swift
//  RNDM
//
//  Created by juger rash on 25.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit
import Firebase

class AddThoughtVC: UIViewController {
    
    //Outlets -:
    @IBOutlet weak var categorySegment : UISegmentedControl!
    @IBOutlet weak var usernameTxtField : UITextField!
    @IBOutlet weak var thoughtTxtView : UITextView!
    @IBOutlet weak var postBtn : UIButton!
    
    //Variables -:
    private var selectedCategory = ThoughtCategory.funny.rawValue

    override func viewDidLoad() {
        super.viewDidLoad()
        categorySegment.layer.cornerRadius = 4
        postBtn.layer.cornerRadius = 4
        thoughtTxtView.layer.cornerRadius = 4
        thoughtTxtView.delegate = self
    }
    
    //Actions -:
    @IBAction func postBtnPressed(_ sender : Any){
        guard let userName = usernameTxtField.text else { return }
        Firebase.Firestore.firestore().collection(THOUGHT_REF).addDocument(data: [
            CATEGORY_THOUGHT : selectedCategory,
            NUM_COMMENTS : 0,
            NUM_LIKES : 0,
            THOUGHT_TXT : thoughtTxtView.text!,
            TIMESTAMP : FieldValue.serverTimestamp(),
            USERNAME : userName] , completion: { (error) in
                if let error = error {
                    debugPrint("Adding document Faild cuz \(error)")
                }else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        
    }
    @IBAction func categorySegmentChanged(_ sender : Any){
        switch categorySegment.selectedSegmentIndex {
        case 0 :
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1 :
            selectedCategory = ThoughtCategory.serious.rawValue
        default:
            selectedCategory = ThoughtCategory.crazy.rawValue
        }
    }
}

extension AddThoughtVC : UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        thoughtTxtView.text = ""
        thoughtTxtView.textColor = .darkGray
    }
}
