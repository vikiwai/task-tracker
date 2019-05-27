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
    
    @IBAction func addNewTask(_ sender: Any) {
        let newRowIndex = taskList.todo.count
        let _ = taskList.newToDo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        taskList.todo.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    func configureHeadlineText(for cell: UITableViewCell, with item: Task) {
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = item.headline
        }
    }
    
    func configureMarker(for cell: UITableViewCell, with item: Task) {
        guard let checkmark = cell.viewWithTag(2) as? UIImageView else {
            return
        }
        
        if item.checked {
            checkmark.isHidden = false
        } else {
            checkmark.isHidden = true
        }
        
        item.switchCheckStatus()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTaskSegue" {
            if let addTaskViewController = segue.destination as? NewTaskTableViewController {
                addTaskViewController.delegate = self
                addTaskViewController.taskList = taskList
            }
        } else if segue.identifier == "EditTaskSegue" {
            if let addTaskViewController = segue.destination as? NewTaskTableViewController {
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let item = taskList.todo[indexPath.row]
                    addTaskViewController.taskToEdit = item
                    addTaskViewController.delegate = self
                }
            }
        }
    }
}

extension TrackerViewController: AddTaskViewControllerDelegate {
    
    func addTaskViewController(_ controller: NewTaskTableViewController, didFinishAdding task: Task) {
        navigationController?.popViewController(animated: true)
        
        let rowIndex = taskList.todo.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func addTaskViewController(_ controller: NewTaskTableViewController, didFinishEditing task: Task) {
        if let index = taskList.todo.firstIndex(of: task) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureHeadlineText(for: cell, with: task)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

