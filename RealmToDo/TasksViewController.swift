//
//  TableViewController.swift
//  RealmToDo
//
//  Created by Denis on 15.03.2020.
//  Copyright © 2020 Denis. All rights reserved.
//

import UIKit
import RealmSwift

class TasksViewController: UITableViewController {
    
    var currentList:TaskList?
    var currentTasks:Results<Task>?
    var competedTask:Results<Task>?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = currentList?.name
        sortingTasks()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? (currentTasks?.count ?? 0) : (competedTask?.count ?? 0)
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASK"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCell", for: indexPath)
        let task = indexPath.section == 0 ? currentTasks?[indexPath.row]: competedTask?[indexPath.row]
        cell.textLabel?.text = task?.name
        cell.detailTextLabel?.text = task?.note
        return cell
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showALert()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
    }
    
    private func sortingTasks () {
        currentTasks = currentList?.tasks.filter("isComplete = false")
        competedTask = currentList?.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
}

extension TasksViewController {
    private func showALert() {
        let alert = AlertController(title: "New List", message: "Please insert new value", preferredStyle: .alert)
        alert.actionWIthTaskList { newValue in
        }
        present(alert, animated: true)
    }
}
