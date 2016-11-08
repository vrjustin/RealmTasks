//
//  Task.swift
//  RealmTasks
//
//  Created by Maronde, Justin on 11/8/16.
//  Copyright © 2016 Justin Maronde. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
 
    dynamic var name = ""
    dynamic var createdAt = NSDate()
    dynamic var notes = ""
    dynamic var isCompleted = false
    
    
}
