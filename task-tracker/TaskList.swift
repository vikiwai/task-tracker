//
//  TaskList.swift
//  task-tracker
//
//  Created by vikiwai on 26/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import Foundation

class TaskList {
    
    enum Priority: Int, CaseIterable {
        case high, medium, low, absence
    }
    
    private var highPriorityTasks: Array<Task> = []
    private var mediumPriorityTasks: Array<Task> = []
    private var lowPriorityTasks: Array<Task> = []
    private var withoutPriorityTasks: Array<Task> = []
    
    init() {
        let task1 = Task()
        let task2 = Task()
        let task3 = Task()
        let task4 = Task()
        
        task1.headline = "Test1"
        task2.headline = "Test2"
        task3.headline = "Test3"
        task4.headline = "Test4"
        
        addTask(task1, for: .high)
        addTask(task2, for: .medium)
        addTask(task3, for: .low)
        addTask(task4, for: .absence)
    }
    
    func newToDo() -> Task {
        let task = Task()
        task.checked = true
        
        withoutPriorityTasks.append(task)
        
        return task
    }
    
    func addTask(_ task: Task, for priority: Priority) {
        switch priority {
        case .high:
            return highPriorityTasks.append(task)
        case .medium:
            return mediumPriorityTasks.append(task)
        case .low:
            return lowPriorityTasks.append(task)
        case .absence:
            return withoutPriorityTasks.append(task)
        }
    }
    
    func todo(for priority: Priority) -> Array<Task> {
        switch priority {
        case .high:
            return highPriorityTasks
        case .medium:
            return mediumPriorityTasks
        case .low:
            return lowPriorityTasks
        case .absence:
            return withoutPriorityTasks
        }
    }
    
    func move(task: Task, to index: Int) {
//        guard let currentIndex = todo.firstIndex(of: task) else {
//            return
//        }
//
//        todo.remove(at: currentIndex)
//        todo.insert(task, at: index)
    }
    
    func remove(_ task: Task, from priority: Priority, at index: Int) {
        switch priority {
        case .high:
            highPriorityTasks.remove(at: index)
        case .medium:
            mediumPriorityTasks.remove(at: index)
        case .low:
            lowPriorityTasks.remove(at: index)
        case .absence:
             withoutPriorityTasks.remove(at: index)
        }
    }
}
