//
//  Extension + UITVCell.swift
//  RealmHW14
//
//  Created by Виктория Воробьева on 06/11/2019.
//  Copyright © 2019 Виктория Воробьева. All rights reserved.
//

import UIKit

extension UITableViewCell {
    
    func configure(with taskList: TaskList) {
        textLabel?.text = taskList.name
        
        let currentTasks = taskList.tasks.filter("isComplete = false")
        let complitedTasks = taskList.tasks.filter("isComplete = true")
        
        if !currentTasks.isEmpty {
            detailTextLabel?.text = "\(currentTasks.count)"
            detailTextLabel?.textColor = .gray
            detailTextLabel?.font = UIFont.systemFont(ofSize: 17)
            
        } else if !complitedTasks.isEmpty {
            detailTextLabel?.text = "✓"
            detailTextLabel?.textColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            detailTextLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        } else {
            detailTextLabel?.text = "0"
        }
    }
}
