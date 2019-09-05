//
//  MainVC.swift
//  RNDM
//
//  Created by juger rash on 24.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class MainVC: UIViewController  , ThoughtDelegate {

    
    //Outlets -:
    @IBOutlet private weak var segmentControl : UISegmentedControl!
    @IBOutlet private weak var tableView : UITableView!

    //Variables -:
    private var thoughts = [Thought]()
    private var selectedCategory = ThoughtCategory.funny.rawValue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DataService.instance.setDidStateChangeListener { (isUserLoggedin) in
            if !isUserLoggedin {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: LOGIN_VC)
                self.present(loginVC, animated: true, completion: nil)
            }else {
                self.setListener()
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DataService.instance.removeThoughtListener()
    }
    //Functions -:
    func thoughtOptionsMenuTapped(thought: Thought) {
        let alert = UIAlertController(title: "Delete", message: "Do you want to Delete your thought?", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .default) { (action) in
            DataService.instance.deleteThought(thought: thought, handler: { (deleteCompleted) in
                if deleteCompleted {
                    alert.dismiss(animated: true, completion: nil)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func setListener(){
        DataService.instance.getAllDocuments(selectedCategory: selectedCategory) { (returnedThoghtsArray) in
            self.thoughts = returnedThoghtsArray
            self.tableView.reloadData()
        }
    }
    //Actions -:
    @IBAction func categoryChanged(_ sender : Any){
        switch segmentControl.selectedSegmentIndex {
        case 0 :
            selectedCategory = ThoughtCategory.funny.rawValue
        case 1 :
            selectedCategory = ThoughtCategory.serious.rawValue
        case 2 :
            selectedCategory = ThoughtCategory.crazy.rawValue
        default:
            selectedCategory = ThoughtCategory.popular.rawValue
        }
        DataService.instance.removeThoughtListener()
        setListener()
        
    }
    @IBAction func logoutBarBtnPressed(_ sender: Any) {
        DataService.instance.logoutUser { (isUserLoggedout) in
            //Nothing to do here :)
        }
    }
    
}

extension MainVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: THOUGHT_CELL, for: indexPath) as? ThoughtCell else { return UITableViewCell() }
        cell.configureCell(thought: thoughts[indexPath.row], delegate: self)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: TO_COMMENTS_SEGUE, sender: thoughts[indexPath.row])
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == TO_COMMENTS_SEGUE {
            if let destinationVC = segue.destination as? CommentsVC {
                if let thought = sender as? Thought {
                    destinationVC.thought = thought 
                }
            }
        }
    }
}

