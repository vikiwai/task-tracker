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
    
    func addTask(_ task: Task, for priority: Priority, at index: Int = -1) {
        switch priority {
        case .high:
            if index < 0 {
                highPriorityTasks.append(task)
            } else {
                highPriorityTasks.insert(task, at: index)
            }
        case .medium:
            if index < 0 {
                mediumPriorityTasks.append(task)
            } else {
                mediumPriorityTasks.insert(task, at: index)
            }
        case .low:
            if index < 0 {
                lowPriorityTasks.append(task)
            } else {
                lowPriorityTasks.insert(task, at: index)
            }
        case .absence:
            if index < 0 {
                withoutPriorityTasks.append(task)
            } else {
                withoutPriorityTasks.insert(task, at: index)
            }
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
    
    func move(task: Task, from sourcePriority: Priority, at sourceIndex: Int,
                          to destinationPriority: Priority, at destinationIndex: Int) {
        remove(task, from: sourcePriority, at: sourceIndex)
        addTask(task, for: destinationPriority, at: destinationIndex)
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
