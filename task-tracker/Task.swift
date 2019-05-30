//
//  Task.swift
//  task-tracker
//
//  Created by vikiwai on 26/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    
    var headline: String = ""
    var date: String = ""
    var priority: String = ""
    var notes: String = ""
    var checked: Bool = false
    
    func switchCheckStatus() {
        checked = !checked
    }
    
    override init() {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        self.headline = aDecoder.decodeObject(forKey: "headline") as! String
        self.date = aDecoder.decodeObject(forKey: "date") as! String
        self.priority = aDecoder.decodeObject(forKey: "priority") as! String
        self.notes = aDecoder.decodeObject(forKey: "notes") as! String
        self.checked = aDecoder.decodeObject(forKey: "checked") as! Bool
    }
    
    func encode(with: NSCoder) {
        with.encode(headline, forKey: "headline")
        with.encode(date, forKey: "date")
        with.encode(priority, forKey: "priority")
        with.encode(notes, forKey: "notes")
        with.encode(checked, forKey: "checked")
    }
}
