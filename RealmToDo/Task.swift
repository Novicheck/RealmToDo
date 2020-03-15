//
//  Task.swift
//  RealmToDo
//
//  Created by Denis on 15.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import RealmSwift

class Task: Object {
    @objc dynamic var name = ""
    @objc dynamic var note = ""
    @objc dynamic var date = Date()
    @objc dynamic var isComplete = false
}
