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
    
    //DataStructure to store the List of TaskList objects
    var taskLists = [TaskList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create some sample data to be displayed
        let taskListA = TaskList()
        taskListA.name = "Wishlist"
        //Add a couple Task items to the taskListA
        let wish1 = Task()
        wish1.name = "iPhone 7"
        wish1.notes = "128GB, Rose-Gold Model"
        
        let wish2 = Task()
        wish2.name = "VW Camper Van"
        wish2.notes = "Scooby Doo Mobile"
        
        taskListA.tasks.append(objectsIn: [wish1, wish2])
        
        //put the taskListA into our taskLists array.
        taskLists.append(taskListA)
        
        tableView.reloadData()
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
        return taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listsCellReuseIdentifier", for: indexPath) as? ListsTableViewCell {
            
            //Configure the cells data now.
            let aListObject = taskLists[indexPath.row]
            cell.configureCell(aTaskList: aListObject)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get the data they selected from taskLists array.
        let selectedTaskList = taskLists[indexPath.row]
        
        performSegue(withIdentifier: "tasksVC", sender: selectedTaskList)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tasksVC" {
            if let tasksViewController = segue.destination as? TasksViewController {
                if let tasksListObject = sender as? TaskList {
                    //Pass the tasksListObject to the tasksViewController
                    tasksViewController.tasksList = tasksListObject
                }
            }
        }
    }
    
    
}

