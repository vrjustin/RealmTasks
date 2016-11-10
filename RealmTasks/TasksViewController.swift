//
//  TasksViewController.swift
//  RealmTasks
//
//  Created by Maronde, Justin on 11/8/16.
//  Copyright © 2016 Justin Maronde. All rights reserved.
//

import UIKit

class TasksViewController: UIViewController {
    
    var tasksList: TaskList!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = tasksList.name
    }


}
