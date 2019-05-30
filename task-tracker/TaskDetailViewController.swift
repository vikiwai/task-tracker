//
//  TaskDetailViewController.swift
//  task-tracker
//
//  Created by vikiwai on 27/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import UIKit

protocol TaskDetailViewControllerDelegate: class {
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishAdding task: Task)
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishEditing task: Task)
}

class TaskDetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    weak var delegate: TaskDetailViewControllerDelegate?
    weak var taskList: TaskList?
    weak var taskToEdit: Task?
    
    @IBOutlet weak var taskHeadline: UITextField!
    @IBOutlet weak var taskDate: UITextField!
    @IBOutlet weak var taskPriority: UITextField!
    @IBOutlet weak var taskNotes: UITextView!
    
    private var datePicker: UIDatePicker?
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM HH:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        taskDate.text = dateFormatter.string(from: datePicker.date)
    }
    
    private var priorityPicker = UIPickerView()
    
    let pickerData: Array<String> = [" ", "Without Priority", "High Priority", "Medium Priority", "Low Priority"]
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        taskPriority.text = pickerData[row]
    }
    
    @IBAction func complete(_ sender: Any) {
        if taskHeadline.text!.isEmpty || taskDate.text!.isEmpty  {
            let alertController = UIAlertController(title: "Not entered all the data", message: "Fields 'headline' and 'date' must be filled", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default) {
                UIAlertAction in NSLog("OK")
            }
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            if let task = taskToEdit, let headline = taskHeadline.text {
                task.headline = headline
                
                delegate?.taskDetailViewController(self, didFinishEditing: task)
            } else {
                if let task = taskList?.newToDo() {
                    if let taskHeadlineField = taskHeadline.text {
                        task.headline = taskHeadlineField
                    }
                    
                    task.checked = false
                    
                    delegate?.taskDetailViewController(self, didFinishAdding: task)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        if let task = taskToEdit {
            title = "Edit Task"
            taskHeadline.text! = task.headline
        } else {
            title = "Add Task"
        }
        
        taskHeadline.delegate = self
        taskDate.delegate = self
        taskPriority.delegate = self
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self,
                              action: #selector(TaskDetailViewController.dateChanged(datePicker:)), for: .valueChanged)
        
        taskDate.inputView = datePicker
        taskPriority.inputView = priorityPicker
        
        priorityPicker.delegate = self
        priorityPicker.dataSource = self
    }
}

extension TaskDetailViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        taskHeadline.resignFirstResponder()
        taskDate.resignFirstResponder()
        taskPriority.resignFirstResponder()
        
        return false
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
