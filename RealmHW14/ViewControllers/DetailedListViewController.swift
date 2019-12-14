//
//  DetailedListViewController.swift
//  RealmHW14
//
//  Created by Виктория Воробьева on 04/11/2019.
//  Copyright © 2019 Виктория Воробьева. All rights reserved.
//

import UIKit
import RealmSwift

class DetailedListViewController: UITableViewController {
    
    var taskList: TaskList!
    
    private var currentTasks: Results<Task>!
    private var complitedTasks: Results<Task>!
    
    private var isEditingMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = taskList.name
        filteringTasks()

    }
    
    @IBAction func editButtonPressed(_ sender: Any) {
        isEditingMode.toggle()
        tableView.setEditing(isEditingMode, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        alertForAddAndUpdateList()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? currentTasks.count : complitedTasks.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        section == 0 ? "CURRENT TASKS" : "COMPLETED TASKS"
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailedList", for: indexPath)

        let task = indexPath.section == 0 ? currentTasks[indexPath.row] : complitedTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let currentTask = indexPath.section == 0 ? currentTasks[indexPath.row] : complitedTasks[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _,_  in
            StorageManager.deleteTask(currentTask)
            self.filteringTasks()
        }
        
        let editAction = UIContextualAction(style: .normal, title: "Edit") { _, _,_  in
            self.alertForAddAndUpdateList(currentTask)
            self.filteringTasks()
        }
        
        let doneAction = UIContextualAction(style: .normal, title: "Done") { _, _,_  in
            StorageManager.makeDone(currentTask)
            self.filteringTasks()
        }
        
        editAction.backgroundColor = .blue
        doneAction.backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [deleteAction, doneAction, editAction])
    }
    
    private func filteringTasks() {
        currentTasks = taskList.tasks.filter("isComplete = false")
        complitedTasks = taskList.tasks.filter("isComplete = true")
        
        tableView.reloadData()
    }
}

extension DetailedListViewController {
    
    private func alertForAddAndUpdateList(_ task: Task? = nil) {
        
        var title = "New Task"
        var doneButton = "Save"
        
        if task != nil {
            title = "Edit Task"
            doneButton = "Update"
        }
          
        let alert = UIAlertController(title: title, message: "Please insert task value", preferredStyle: .alert)
        var taskTextField: UITextField!
        var noteTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let text = taskTextField.text , !text.isEmpty else { return }
            
            if let task = task {
                if let newNote = noteTextField.text, !newNote.isEmpty {
                    StorageManager.editTask(task, with: text, and: newNote)
                    self.tableView.reloadData()
                } else {
                    StorageManager.editTask(task, with: text, and: "")
                    self.tableView.reloadData()
                }
            } else {
                let task = Task()
                task.name = text
                
                if let note = noteTextField.text, !note.isEmpty {
                    task.note = noteTextField.text ?? ""
                }
                
                StorageManager.saveTask(task, for: self.taskList)
                self.filteringTasks()
            }
        }
          
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            taskTextField = textField
            taskTextField.placeholder = "New task"
            
            if let task = task {
                taskTextField.text = task.name
            }
        }
        
        alert.addTextField { textField in
            noteTextField = textField
            noteTextField.placeholder = "Note"
            
            if let task = task {
                noteTextField.text = task.note
            }
        }
        
        present(alert, animated: true)
    }
}
