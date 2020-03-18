//
//  Extension + UITableViewCell.swift
//  RealmToDo
//
//  Created by Denis on 18.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit

extension UITableViewCell {
    func configur (with taskList: TaskList) {
        let currentTasks = taskList.tasks.filter("isComplete = false")
        let comletedTask = taskList.tasks.filter("isComplete = true")
        textLabel?.text = taskList.name
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            accessoryType = .none
        } else if !comletedTask.isEmpty {
            detailTextLabel?.text = nil
            accessoryType = .checkmark
        } else {
            detailTextLabel?.text = "0"
            accessoryType = .none
        }
    }
}
