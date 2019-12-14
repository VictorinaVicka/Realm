//
//  ToDoViewController.swift
//  RealmHW14
//
//  Created by Виктория Воробьева on 04/11/2019.
//  Copyright © 2019 Виктория Воробьева. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoViewController: UITableViewController {
    
    var taskLists: Results<TaskList>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        taskLists = realm.objects(TaskList.self)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        alerForAddAndUpdateList()
    }
    
    @IBAction func sortingList(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            taskLists = taskLists.sorted(byKeyPath: "name")
        } else {
            taskLists = taskLists.sorted(byKeyPath: "date", ascending: false)
        }
        
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List", for: indexPath)
        let taskList = taskLists[indexPath.row]
        cell.configure(with: taskList)

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentTaskList = taskLists[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, completion in
            StorageManager.deleteTaskList(currentTaskList)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _,_  in
            self.alerForAddAndUpdateList(currentTaskList) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _,_  in
            StorageManager.mackAllDone(currentTaskList)
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        editAction.backgroundColor = .blue
        doneAction.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, doneAction, editAction])
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = tableView.indexPathForSelectedRow {
            let taskList = taskLists[indexPath.row]
            let tasksVC = segue.destination as! DetailedListViewController
            tasksVC.taskList = taskList
            
        }
    }
}

extension ToDoViewController {
    
    private func alerForAddAndUpdateList(_ taskList: TaskList? = nil, completion: (() -> Void)? = nil) {
        
        var title = "New list"
        var doneButtom = "Save"
        
        if taskList != nil {
            title = "Edited list"
            doneButtom = "Update"
        }
        
        let alert = UIAlertController(title: title, message: "Please insert new value", preferredStyle: .alert)
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButtom, style: .default) { _ in
            guard let text = alertTextField.text , !text.isEmpty else { return }
            
            if let taskList = taskList {
                StorageManager.editTaskList(taskList, with: text)
                completion?()
            } else {
                let taskList = TaskList()
                taskList.name = text
                StorageManager.saveTaskList(taskList)
                self.tableView.insertRows(at: [IndexPath(
                    row: self.taskLists.count - 1, section: 0)], with: .automatic
                )
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            alertTextField = textField
            alertTextField.placeholder = "List Name"
            
            if let taskList = taskList {
                alertTextField.text = taskList.name
            }
        }
        present(alert, animated: true)
    }
}
