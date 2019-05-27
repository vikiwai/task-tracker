//
//  NewTaskTableViewController.swift
//  task-tracker
//
//  Created by vikiwai on 27/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class NewTaskTableViewController: UIViewController {

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
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
