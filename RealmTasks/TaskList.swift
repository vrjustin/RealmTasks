//
//  TaskList.swift
//  RealmTasks
//
//  Created by Maronde, Justin on 11/8/16.
//  Copyright © 2016 Justin Maronde. All rights reserved.
//

import Foundation
import RealmSwift

class TaskList: Object {
    
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    
    let tasks = List<Task>()
    
}
