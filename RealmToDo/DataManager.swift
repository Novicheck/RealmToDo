//
//  DataManager.swift
//  RealmToDo
//
//  Created by Denis on 15.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class DataManager {
    static let shared = DataManager()
    
    func saveTaskLists(_ taskLists: [TaskList]) {
       try! realm.write {
            realm.add(taskLists)
        }
    }
}
