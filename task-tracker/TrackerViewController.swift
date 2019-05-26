//
//  TrackerViewController.swift
//  task-tracker
//
//  Created by vikiwai on 25/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import UIKit

class TrackerViewController: UITableViewController {
    
    var row0Item: Task
    
    required init?(coder aDecoder: NSCoder) {
        row0Item = Task()
        row0Item.headline = "Test"
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackerItem", for: indexPath)
        
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = row0Item.headline
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            if !row0Item.checked {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            row0Item.checked = !row0Item.checked
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

}

