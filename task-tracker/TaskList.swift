//
//  TaskList.swift
//  task-tracker
//
//  Created by vikiwai on 26/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import Foundation

class TaskList {
    
    var todo: Array<Task> = []
    
    init() {
        let item = Task()
        item.headline = "Test"
        
        todo.append(item)
    }
    
    func newToDo() -> Task {
        let item = Task()
        item.headline = "New"
        
        todo.append(item)
        
        return item
    }
    
    func move(task: Task, to index: Int) {
        guard let currentIndex = todo.firstIndex(of: task) else {
            return
        }
        
        todo.remove(at: currentIndex)
        todo.insert(task, at: index)
    }
    
    func remove(tasks: [Task]) {
        for task in tasks {
            if let index = todo.firstIndex(of: task) {
                todo.remove(at: index)
            }
        }
    }
}
