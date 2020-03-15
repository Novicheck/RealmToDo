//
//  TaskList.swift
//  RealmToDo
//
//  Created by Denis on 15.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import RealmSwift

class TaskList: Object {
    @objc dynamic var name = ""
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
