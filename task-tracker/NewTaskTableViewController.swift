//
//  NewTaskTableViewController.swift
//  task-tracker
//
//  Created by vikiwai on 27/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class NewTaskTableViewController: UIViewController {

    @IBAction func complete(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
