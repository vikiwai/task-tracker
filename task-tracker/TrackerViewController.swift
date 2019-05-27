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
    var tableData: Array<Array<Task?>?>!
    
    @IBAction func addNewTask(_ sender: Any) {
        let newRowIndex = taskList.todo.count
        let _ = taskList.newToDo()
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    @IBAction func deleteTasks(_ sender: Any) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            var selectedTasks: Array<Task> = []
            for indexPath in selectedRows {
                selectedTasks.append(taskList.todo[indexPath.row])
            }
            
            taskList.remove(tasks: selectedTasks)
            
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
        
        let sectionTitleCount = UILocalizedIndexedCollation().sectionTitles.count
        var allSections = Array<Array<Task?>?>(repeatElement(nil, count: sectionTitleCount))
        var sectionNumber = 0
        let collation = UILocalizedIndexedCollation.current()
        
        for task in taskList.todo {
            sectionNumber = collation.section(for: task, collationStringSelector: #selector(getter:Task.headline))
            
            if allSections[sectionNumber] == nil {
                allSections[sectionNumber] = Array<Task?>()
            }
            
            allSections[sectionNumber]!.append(task)
        }
        
        tableData = allSections
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: true)
        tableView.setEditing(tableView.isEditing, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section] == nil ? 0 : tableData[section]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerItem", for: indexPath)
        //let task = taskList.todo[indexPath.row]
        if let task = tableData[indexPath.section]?[indexPath.row] {
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
            let task = taskList.todo[indexPath.row]
            task.switchCheckStatus()
            
            configureMarker(for: cell, with: task)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        taskList.todo.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        taskList.move(task: taskList.todo[sourceIndexPath.row], to: destinationIndexPath.row)
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
                if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
                    let task = taskList.todo[indexPath.row]
                    taskDetailViewController.taskToEdit = task
                    taskDetailViewController.delegate = self
                }
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return UILocalizedIndexedCollation.current().sectionTitles
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return UILocalizedIndexedCollation.current().sectionTitles[section]
    }
}

extension TrackerViewController: TaskDetailViewControllerDelegate {
    
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishAdding task: Task) {
        navigationController?.popViewController(animated: true)
        
        let rowIndex = taskList.todo.count - 1
        let indexPath = IndexPath(row: rowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
    }
    
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishEditing task: Task) {
        if let index = taskList.todo.firstIndex(of: task) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureHeadlineText(for: cell, with: task)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

