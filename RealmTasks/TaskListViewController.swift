//
//  ViewController.swift
//  RealmTasks
//
//  Created by Maronde, Justin on 11/8/16.
//  Copyright © 2016 Justin Maronde. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        populateDummyData()
    }
    
    func populateDummyData() {
        //Instantiate a TaskList and assign the name property.
        let taskListA = TaskList()
        taskListA.name = "Wishlist"
        
        //Example 1 instantiate the Realm object 'Task' and set the properties.
        let wish1 = Task()
        wish1.name = "iPhone7"
        wish1.notes = "64GB, Rose-Gold"
        
        //Example 2 instantiate the Realm object 'Task' and pass in the key-value pairs during the instantitation.
        let wish2 = Task(value: ["name": "Game Console", "notes": "Playstation4"])
        
        //Example 3 instantiate the Realm object 'Task' and pass in the values in the correct order to set the properties
        //without having to define the keys the values go to.
        let wish3 = Task(value: ["Car", NSDate(), "Auto R8", false])
        
        //Append objectsIn an array. Normally the array would already be defined and you would just pass the array variable.
        //here we are explicitly creating the array with the objects in it.
        taskListA.tasks.append(objectsIn: [wish1, wish2, wish3])
        
        //Append objects to the taskListB by nesting objects
        let taskListB = TaskList(value: ["MoviesList", NSDate(), [["The Martian", NSDate(), "", false], ["The Maze Runner", NSDate(), "", true]]])
        
        
    }

}

