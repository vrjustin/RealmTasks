//
//  TasksViewController.swift
//  RealmTasks
//
//  Created by Maronde, Justin on 11/8/16.
//  Copyright © 2016 Justin Maronde. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasksList: TaskList!
    var openTasks: Results<Task>!
    var completedTasks: Results<Task>!
    var currentCreateAction: UIAlertAction!
    var isEditingMode = false

    @IBOutlet weak var tableView: UITableView!
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = tasksList.name
        readTasksAndUpdateUI()
    }
    
    // MARK: - User Actions
    @IBAction func editUserAction(_ sender: UIBarButtonItem) {
        isEditingMode = !isEditingMode //toggles from current value.
        self.tableView.setEditing(isEditingMode, animated: true)
    }

    @IBAction func addUserAction(_ sender: UIBarButtonItem) {
        self.displayAlertToAddTask(theTask: nil)
    }
    
    // MARK: - Data Methods
    func readTasksAndUpdateUI() {
        //Get the Completed Tasks First.
        completedTasks = self.tasksList.tasks.filter("isCompleted = true")
        openTasks = self.tasksList.tasks.filter("isCompleted = false")
        self.tableView.reloadData()
    }
    
    //Enable the create action of the alert only if textfield text is not empty
    func taskNameFieldDidChange(textField:UITextField){
        self.currentCreateAction.isEnabled = (textField.text?.characters.count)! > 0
    }
    
    func displayAlertToAddTask(theTask: Task!) {
        var title = "New Task"
        var doneTitle = "Create"
        if theTask != nil {
            title = "Update Task"
            doneTitle = "Update"
        }
        
        let alertController = UIAlertController(title: title, message: "Write the name of your task.", preferredStyle: UIAlertControllerStyle.alert)
        let createAction = UIAlertAction(title: doneTitle, style: UIAlertActionStyle.default, handler: { (action) -> Void in
            
            let taskName = alertController.textFields?.first?.text
            
            if theTask != nil {
                //update mode
                try! uiRealm.write {
                    theTask.name = taskName!
                    self.readTasksAndUpdateUI()
                }
            } else {
                //create mode
                let newTask = Task()
                newTask.name = taskName!
                try! uiRealm.write {
                    self.tasksList.tasks.append(newTask)
                    self.readTasksAndUpdateUI()
                }
            }
            
        })
        
        alertController.addAction(createAction)
        createAction.isEnabled = false
        self.currentCreateAction = createAction
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        alertController.addTextField(configurationHandler: { (textField) -> Void in
            textField.placeholder = "Task Name"
            textField.addTarget(self, action: #selector(TasksViewController.taskNameFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
            if theTask != nil {
                textField.text = theTask.name
            }
        })
        
        self.present(alertController, animated: true, completion: nil)
    }


    // MARK: - Tableview Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return openTasks.count
        }
        return completedTasks.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Open Tasks"
        }
        return "Completed Tasks"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)

        var task: Task!
        if indexPath.section == 0 {
            task = openTasks[indexPath.row]
        } else {
            task = completedTasks[indexPath.row]
        }
        cell.textLabel?.text = task.name

        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowActionStyle.destructive, title: "Delete", handler: { (deleteAction, indexPath) -> Void in
            //Deletion will go here.
            var taskToBeDeleted: Task!
            if indexPath.section == 0 {
                taskToBeDeleted = self.openTasks[indexPath.row]
            } else {
                taskToBeDeleted = self.completedTasks[indexPath.row]
            }
            
            try! uiRealm.write {
                uiRealm.delete(taskToBeDeleted)
                self.readTasksAndUpdateUI()
            }
            
        })
        let doneAction = UITableViewRowAction(style: UITableViewRowActionStyle.normal, title: "Done", handler: { (doneAction, indexPath) -> Void in
            //Editing will go here.
            var taskToBeUpdated: Task!
            if indexPath.section == 0 {
                taskToBeUpdated = self.openTasks[indexPath.row]
            } else {
                taskToBeUpdated = self.completedTasks[indexPath.row]
            }
            
            try! uiRealm.write {
                taskToBeUpdated.isCompleted = true
                self.readTasksAndUpdateUI()
            }
        })
        return [deleteAction, doneAction]
    }

}
