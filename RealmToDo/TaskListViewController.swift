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
        taskLists = realm?.objects(TaskList.self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func sortingList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            taskLists = taskLists?.sorted(byKeyPath: "name", ascending: true)
        } else {
            taskLists = taskLists?.sorted(byKeyPath: "date", ascending: false)
        }
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showALert()
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
    // MARK: - Table view datasource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return taskLists?.count ?? 0
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskListCell", for: indexPath)
        guard let task = taskLists?[indexPath.row] else {return UITableViewCell()}
        cell.configur(with: task)
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTaskViewController", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        guard let currenList = taskLists?[indexPath.row] else {return nil}
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { _, _ in
            DataManager.shared.delete(taskList: currenList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { _, _ in
            self.showALert(with: currenList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        editAction.backgroundColor = .orange
        let doneAction = UITableViewRowAction(style: .normal, title: "Done") { _, _ in
            DataManager.shared.done(taskList: currenList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        doneAction.backgroundColor = .green
        return [deleteAction, doneAction, editAction]
    }
}

extension TaskListViewController {
    private func showALert(with taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        let alert = AlertController(title: "New List", message: "Please insert new value", preferredStyle: .alert)
        alert.actionWIthTaskList(for: taskList) { [weak self] newValue in
            guard let self = self else {return}
            if let taskList = taskList, let completion = completion {
                DataManager.shared.edit(taskList: taskList, with: newValue)
                completion()
            } else {
                let taskList = TaskList()
                taskList.name = newValue
                DataManager.shared.save(taskList: taskList)
                let rowIndex = IndexPath(row: (self.taskLists?.count ?? 0) - 1, section: 0)
                self.tableView.insertRows(at: [rowIndex], with: .left)
            }
        }
        present(alert, animated: true)
    }
}

