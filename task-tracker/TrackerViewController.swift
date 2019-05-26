//
//  TrackerViewController.swift
//  task-tracker
//
//  Created by vikiwai on 25/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class TrackerViewController: UITableViewController {
    
    var taskList: TaskList
    
    required init?(coder aDecoder: NSCoder) {
        taskList = TaskList()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.todo.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerItem", for: indexPath)
        let item = taskList.todo[indexPath.row]
        
        configureHeadlineText(for: cell, with: item)
        configureMarker(for: cell, with: item)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = taskList.todo[indexPath.row]
            configureMarker(for: cell, with: item)
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func configureHeadlineText(for cell: UITableViewCell, with item: Task) {
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = item.headline
        }
    }
    
    func configureMarker(for cell: UITableViewCell, with item: Task) {
        if item.checked {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        item.switchCheckStatus()
    }
}

