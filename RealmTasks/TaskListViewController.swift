//
//  ViewController.swift
//  RealmTasks
//
//  Created by Maronde, Justin on 11/8/16.
//  Copyright © 2016 Justin Maronde. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func editBBItemAction(_ sender: UIBarButtonItem) {
        print("editBBItemAction Touched");
    }
    
    @IBAction func addBBItemAction(_ sender: UIBarButtonItem) {
        print("addBBItemAction Touched");
    }
    
    @IBAction func segmentedControllerChangedAction(_ sender: UISegmentedControl) {
        print("segmentedControllerChanged Touched")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listsCellReuseIdentifier", for: indexPath) as? ListsTableViewCell {
            
            //Configure the cells data now.
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    
    
}

