//
//  DataManager.swift
//  RealmToDo
//
//  Created by Denis on 15.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import RealmSwift

let realm = try? Realm()

class DataManager {
    
    static let shared = DataManager()
    
    func save(taskList: TaskList) {
        do {
            try realm?.write {
                realm?.add(taskList)
            }
        } catch let error {
            print (error.localizedDescription)
        }
    }
    
    func saveTask (task: Task, tasklist: TaskList) {
        do {
            try realm?.write {
                tasklist.tasks.append(task)
            }
        } catch let error {
            print (error.localizedDescription)
        }
    }
    
    func delete (taskList:TaskList) {
        do {
            try realm?.write {
                let tasks = taskList.tasks
                realm?.delete(tasks)
                realm?.delete(taskList)
            }
        } catch let error {
            print (error.localizedDescription)
        }
    }
    
    func edit (taskList: TaskList, with newList: String) {
        do {
            try realm?.write {
                taskList.name = newList
            }
        } catch let error {
            print (error.localizedDescription)
        }
    }
    
    func done (taskList: TaskList) {
        do {
            try realm?.write {
                taskList.tasks.setValue(true, forKey: "isComplete")
            }
        } catch let error {
            print (error.localizedDescription)
        }
    }
    
    func edit (task: Task, with newTask: String, and newNote: String) {
        do {
            try realm?.write {
                task.name = newTask
                task.note = newNote
            }
        } catch let error {
            print (error.localizedDescription)
        }
    }
    
    func delete (task: Task) {
        do {
            try realm?.write {
                realm?.delete(task)
            }
        } catch let error {
            print (error.localizedDescription)
        }
    }
    
    func done (task: Task) {
        do {
            try realm?.write {
                task.isComplete.toggle()
            }
        } catch let error {
            print (error.localizedDescription)
        }
    }
}
