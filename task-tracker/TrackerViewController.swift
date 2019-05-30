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

    private func priorityForSectionIndex(_ index: Int) -> TaskList.Priority? {
        return TaskList.Priority(rawValue: index)
    }
    
    @IBAction func addNewTask(_ sender: Any) {
        let newRowIndex = taskList.todo(for: .absence).count
        let _ = taskList.newToDo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    @IBAction func deleteTasks(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            for indexPath in selectedRows {
                if let priority = priorityForSectionIndex(indexPath.section) {
                    let todo = taskList.todo(for: priority)
                    let rowToDelete = indexPath.row > todo.count - 1 ? todo.count - 1 : indexPath.row
                    let task = todo[rowToDelete ]
                    taskList.remove(task, from: priority, at: indexPath.row)
                }
            }
            
            tableView.beginUpdates()
            tableView.deleteRows(at: selectedRows, with: .automatic)
            tableView.endUpdates()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        taskList = TaskList()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = editButtonItem
        
        tableView.allowsMultipleSelectionDuringEditing = true
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let priority = priorityForSectionIndex(section) {
            return taskList.todo(for: priority).count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerItem", for: indexPath)

        if let priority = priorityForSectionIndex(indexPath.section) {
            let todo = taskList.todo(for: priority)
            let task = todo[indexPath.row]
            
            configureHeadlineText(for: cell, with: task)
            configureMarker(for: cell, with: task)
        }
    
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            return
        }
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if let priority = priorityForSectionIndex(indexPath.section) {
                let todo = taskList.todo(for: priority)
                let task = todo[indexPath.row]
                task.switchCheckStatus()
                
                configureMarker(for: cell, with: task)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if let priority = priorityForSectionIndex(indexPath.section) {
            let task = taskList.todo(for: priority)[indexPath.row]
            taskList.remove(task, from: priority, at: indexPath.row)
            let indexPaths = [indexPath]
            
            tableView.deleteRows(at: indexPaths, with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath,
                                                      to destinationIndexPath: IndexPath) {
        if let sourcePriority = priorityForSectionIndex(sourceIndexPath.section),
           let destinationPriority = priorityForSectionIndex(destinationIndexPath.section) {
            let task = taskList.todo(for: sourcePriority)[sourceIndexPath.row]
            taskList.move(task: task, from: sourcePriority, at: sourceIndexPath.row,
                                      to: destinationPriority, at: destinationIndexPath.row)
        }
        
        tableView.reloadData()
    }
    
    func configureHeadlineText(for cell: UITableViewCell, with task: Task) {
        if let checkmarkCell = cell as? TrackerTableViewCell {
            checkmarkCell.headlineLabel.text = task.headline
        }
    }
    
    func configureMarker(for cell: UITableViewCell, with task: Task) {
        guard let checkmarkCell = cell as? TrackerTableViewCell else {
            return
        }
        
        if task.checked {
            checkmarkCell.checkmarkImage.isHidden = false
        } else {
            checkmarkCell.checkmarkImage.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTaskSegue" {
            if let taskDetailViewController = segue.destination as? TaskDetailViewController {
                taskDetailViewController.delegate = self
                taskDetailViewController.taskList = taskList
            }
        } else if segue.identifier == "EditTaskSegue" {
            if let taskDetailViewController = segue.destination as? TaskDetailViewController {
                if let cell = sender as? UITableViewCell,
                    let indexPath = tableView.indexPath(for: cell),
                    let priority = priorityForSectionIndex(indexPath.section) {
                        let task = taskList.todo(for: priority)[indexPath.row]
                        taskDetailViewController.taskToEdit = task
                        taskDetailViewController.delegate = self
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return TaskList.Priority.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String? = nil
        
        if let priority = priorityForSectionIndex(section) {
            switch priority {
            case .high:
                title = "High Priority"
            case .medium:
                title = "Medium Priority"
            case .low:
                title = "Low Priority"
            case .absence:
                title = "Without Priority"
            }
        }
        
        return title
    }
}

extension TrackerViewController: TaskDetailViewControllerDelegate {
    
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishAdding task: Task) {
        navigationController?.popViewController(animated: true)
        
        let rowIndex = taskList.todo(for: .absence).count - 1
        let indexPath = IndexPath(row: rowIndex, section: TaskList.Priority.absence.rawValue)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishEditing task: Task) {
        for priority in TaskList.Priority.allCases {
            let currentList = taskList.todo(for: priority)
            if let index = currentList.firstIndex(of: task) {
                let indexPath = IndexPath(row: index, section: priority.rawValue)
                if let cell = tableView.cellForRow(at: indexPath) {
                    configureHeadlineText(for: cell, with: task)
                }
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

