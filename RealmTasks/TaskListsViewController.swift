//
//  TaskListsViewController.swift
//  RealmTasks
//
//  Created by Maronde, Justin on 11/8/16.
//  Copyright © 2016 Justin Maronde. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var segmentedController: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    //DataStructure to store the List of TaskList objects
    var taskListsResults: Results<TaskList>!
    //Boolean to track if we are in editing mode or not.
    var isEditingMode = false
    var currentCreateAction: UIAlertAction!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        readTasksAndUpdateUI()
    }
    
    func setupSampleData() {
        
        //TASK LIST A
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
        
        
        
        //TASK LIST B
        let taskListB = TaskList()
        taskListB.name = "Groceries"
        //Add a couple Task Items to the taskListB
        let groceryItem1 = Task()
        groceryItem1.name = "Apples"
        groceryItem1.notes = "Michigan Honeycrisp"
        
        let groceryItem2 = Task()
        groceryItem2.name = "Bananas"
        groceryItem2.notes = "Quantity of 5 and as green as possible"
        
        let groceryItem3 = Task()
        groceryItem3.name = "Cottage Cheese"
        groceryItem3.notes = "Lowfat"
        
        taskListB.tasks.append(objectsIn: [groceryItem1, groceryItem2, groceryItem3])

        //Write these objects to Realm
        try! uiRealm.write({ () -> Void in
            uiRealm.add([taskListA, taskListB])
            self.readTasksAndUpdateUI()
        })
        
    }

    @IBAction func editBBItemAction(_ sender: UIBarButtonItem) {
        isEditingMode = true
        //This technique sets the entire table into edit mode.
        self.tableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func addBBItemAction(_ sender: UIBarButtonItem) {
        self.displayAlertToAddTaskList(theList: nil)
    }
    
    @IBAction func segmentedControllerChangedAction(_ sender: UISegmentedControl) {
        print("segmentedControllerChanged Touched")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskListsResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "listsCellReuseIdentifier", for: indexPath) as? ListsTableViewCell {
            
            //Configure the cells data now.
            let aListObject = taskListsResults[indexPath.row]
            cell.configureCell(aTaskList: aListObject)
            
            return cell
            
        } else {
            return UITableViewCell()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get the data they selected from taskLists array.
        let selectedTaskList = taskListsResults[indexPath.row]
        performSegue(withIdentifier: "tasksVC", sender: selectedTaskList)
    }
    
    //This method will allow us to individually, at the cell level, control what edit actions can be
    //performed on a tablecell. This is different than the entire table being in edit mode.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: { (deleteAction, indexPath) -> Void in
            let listToBeDeleted = self.taskListsResults[indexPath.row]
            //Delete from Realm..
            try! uiRealm.write({ () -> Void in
                uiRealm.delete(listToBeDeleted)
                self.readTasksAndUpdateUI()
            })
        })
        let editAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Edit", handler: { (editAction, indexPath) -> Void in
            let listToBeUpdated = self.taskListsResults[indexPath.row]
            self.displayAlertToAddTaskList(theList: listToBeUpdated)
        })
        return [deleteAction, editAction]
    }

    
    
    
    
    
    func readTasksAndUpdateUI() {
        //Retrieve all Realm objects that are of type TaskList
        taskListsResults = uiRealm.objects(TaskList.self)
        self.tableView.setEditing(isEditingMode, animated: true)
        if taskListsResults.count > 0 {
            self.tableView.reloadData()
        }
    }
    
    func listNameFieldDidChange(textField: UITextField) {
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    func displayAlertToAddTaskList(theList: TaskList!) {
        
        var title = "New Tasks List"
        var doneTitle = "Create"
        //But if theList is not nil - then we are updating an existing one.
        if theList != nil {
            title = "Update Tasks List"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your tasks list.", preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let listName = alertController.textFields?.first?.text
            
            if theList != nil {
                //update mode
                try! uiRealm.write {
                    theList.name = listName!
                    self.readTasksAndUpdateUI()
                }
            } else {
                //create mode
                let newTaskList = TaskList()
                newTaskList.name = listName!
                
                try! uiRealm.write {
                    uiRealm.add(newTaskList)
                    self.readTasksAndUpdateUI()
                }
                
            }
        })
        
        alertController.addAction(createAction)
        createAction.isEnabled = false;
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Task List Name"
            textField.addTarget(self, action: #selector(TaskListsViewController.listNameFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
            if theList != nil {
                textField.text = theList.name
            }
            
        })
        
        self.present(alertController, animated: true, completion: nil)
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

