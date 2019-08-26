//
//  MainVC.swift
//  RNDM
//
//  Created by juger rash on 24.08.19.
//  Copyright © 2019 juger rash. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
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
        setListener()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        DataService.instance.removeThoughtListener()
    }
    //Functions -:
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
    
}

extension MainVC : UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thoughts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: THOUGHT_CELL, for: indexPath) as? ThoughtCell else { return UITableViewCell() }
        cell.configureCell(thought: thoughts[indexPath.row])
        return cell
    }
}

