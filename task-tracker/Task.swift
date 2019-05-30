//
//  Task.swift
//  task-tracker
//
//  Created by vikiwai on 26/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import Foundation

class Task: NSObject {
    
    var headline: String = ""
    var date: String = ""
    var priority: String = ""
    var notes: String = ""
    var checked: Bool = false
    
    func switchCheckStatus() {
        checked = !checked
    }
}
