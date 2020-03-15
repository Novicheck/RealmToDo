//
//  ViewController.swift
//  RealmToDo
//
//  Created by Denis on 15.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class TaskListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var taskLists: Results<TaskList>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        taskLists = realm.objects(TaskList.self)
//                let shoppingList = TaskList()
//                shoppingList.name = "Shopping List"
//                let milk = Task()
//                milk.name = "Milk"
//                milk.note = "2"
//                shoppingList.tasks.append(milk)
//                let bread = Task(value: ["Bread", "Black", Date(), true])
//                let apples = Task(value: ["name": "Apples", "isComplete": true])
//                shoppingList.tasks.insert(contentsOf: [bread, apples], at: 1)
//        DispatchQueue.main.async {
//            DataManager.shared.saveTaskLists([shoppingList])
//        }
    }

    @IBAction func sortingList(_ sender: UISegmentedControl) {
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showALert()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    //Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        let taskList = taskLists?[indexPath.row]
        let tasksVC = segue.destination as! TasksViewController
        tasksVC.currentList = taskList
    }
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskLists?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        let task = taskLists?[indexPath.row]
        cell.textLabel?.text = task?.name
        cell.detailTextLabel?.text = String(task?.tasks.count ?? 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTaskViewController", sender: nil)
    }
}

extension TaskListViewController {
    private func showALert() {
        let alert = AlertController(title: "New List", message: "Please insert new value", preferredStyle: .alert)
        alert.actionWIthTaskList { newValue in
        }
        present(alert, animated: true)
    }
}

