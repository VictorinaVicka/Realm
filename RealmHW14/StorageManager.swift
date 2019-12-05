//
//  StorageManager.swift
//  RealmHW14
//
//  Created by Виктория Воробьева on 04/11/2019.
//  Copyright © 2019 Виктория Воробьева. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveTaskList(_ taskList: TaskList) {
        try! realm.write {
            realm.add(taskList)
        }
    }
    
    static func saveTask(_ task: Task, for taskList: TaskList) {
        try! realm.write {
            taskList.tasks.append(task)
        }
    }
    
    static func deleteTaskList(_ taskList: TaskList) {
        try! realm.write {
            let tasks = taskList.tasks
            realm.delete(tasks)
            realm.delete(taskList)
        }
    }
    
    static func editTaskList(_ taskList: TaskList, with newListName: String) {
        try! realm.write {
            taskList.name = newListName
        }
    }
    
    static func mackAllDone(_ taskList: TaskList) {
         try! realm.write {
            taskList.tasks.setValue(true, forKey: "isComplete")
        }
    }
    
    static func editTask(_ task: Task, with newTask: String, and newNote: String) {
        try! realm.write {
            task.name = newNote
            task.note = newNote
        }
    }
    
    static func deleteTask(_ task: Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    static func makeDone(_ task: Task) {
        try! realm.write {
            task.isComplete.toggle()
        }
    }
}

