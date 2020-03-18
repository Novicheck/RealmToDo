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
    private var currentTasks:Results<Task>?
    private var competedTask:Results<Task>?
    private var isEditingMode: Bool = false
    
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
    
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let selectedTask = indexPath.section == 0 ? currentTasks?[indexPath.row]: competedTask?[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: "Dlete") { _, _, _ in
            if let task = selectedTask{
                DataManager.shared.delete(task: task)
                self.sortingTasks()
            }
        }
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _, _ in
            self.showALert(with: selectedTask)
        }
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _, _ in
            if let task = selectedTask{
                DataManager.shared.done(task: task)
                self.sortingTasks()
            }
        }
        editAction.backgroundColor = .orange
        doneAction.backgroundColor = .green
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, doneAction])
    }
    

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        showALert()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
    }
    
    private func sortingTasks () {
        currentTasks = currentList?.tasks.filter("isComplete = false")
        competedTask = currentList?.tasks.filter("isComplete = true")
        tableView.reloadData()
    }
}

extension TasksViewController {
    private func showALert(with task: Task? = nil) {
        let alert = AlertController(title: "New List", message: "Please insert new value", preferredStyle: .alert)
        alert.actionWithTask(for: task) { [weak self] newValue, note in
            guard let self = self else {return}
            if let task = task {
                DataManager.shared.edit(task: task, with: newValue, and: note)
                self.sortingTasks()
            } else {
                let task = Task()
                task.name = newValue
                task.note = note
                guard let taskList = self.currentList else {return}
                DataManager.shared.saveTask(task: task, tasklist: taskList)
                self.sortingTasks()
            }
        }
        present(alert, animated: true)
    }
}
