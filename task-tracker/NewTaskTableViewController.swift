//
//  NewTaskTableViewController.swift
//  task-tracker
//
//  Created by vikiwai on 27/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import UIKit

protocol AddTaskViewControllerDelegate: class {
    func addTaskViewController(_ controller: NewTaskTableViewController, didFinishAdding task: Task)
}

class NewTaskTableViewController: UIViewController {

    weak var delegate: AddTaskViewControllerDelegate?
    weak var taskList: TaskList?
    weak var taskToEdit: Task?
    
    @IBOutlet weak var taskHeadline: UITextField!
    @IBOutlet weak var taskData: UITextField!
    @IBOutlet weak var taskPriority: UITextField!
    @IBOutlet weak var taskNotes: UITextView!
    
    @IBAction func complete(_ sender: Any) {
        if taskHeadline.text!.isEmpty || taskData.text!.isEmpty  {
            let alertController = UIAlertController(title: "Not entered all the data", message: "Fields 'headline' and 'date' must be filled", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                UIAlertAction in NSLog("OK")
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
            
            let task = Task()
            if let taskHeadlineField = taskHeadline.text {
                task.headline = taskHeadlineField
            }
            task.checked = false
            delegate?.addTaskViewController(self, didFinishAdding: task)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let task = taskToEdit {
            title = "Edit Task"
            taskHeadline.text! = task.headline
        }
        
        taskHeadline.delegate = self
        taskData.delegate = self
        taskPriority.delegate = self
    }
}

extension NewTaskTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskHeadline.resignFirstResponder()
        taskData.resignFirstResponder()
        taskPriority.resignFirstResponder()
        
        return false
    }
}
