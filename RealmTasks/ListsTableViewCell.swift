//
//  ListsTableViewCell.swift
//  RealmTasks
//
//  Created by Maronde, Justin on 11/8/16.
//  Copyright © 2016 Justin Maronde. All rights reserved.
//

import UIKit

class ListsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var listTitleLabel: UILabel!
    @IBOutlet weak var tasksCountLabel: UILabel!
    
    func configureCell(aTaskList: TaskList) {
        listTitleLabel.text = aTaskList.name
        tasksCountLabel.text = "\(aTaskList.tasks.count) Tasks"
    }

}
