//
//  TodayViewController.swift
//  Task Tracker Widget
//
//  Created by vikiwai on 30/05/2019.
//  Copyright © 2019 Victoria Bunyaeva. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
        
    @IBOutlet weak var widgetHeadline: UILabel!
    @IBOutlet weak var widgetDate: UILabel!
    @IBOutlet weak var openTask: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.init(suiteName: "group.vikiwai.widget")!
        
        do {
            let highPriorityTasks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userDefaults.data(forKey: "highPriorityTasks")!) as? Array<Task>
            let mediumPriorityTasks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userDefaults.data(forKey: "mediumPriorityTasks")!) as? Array<Task>
            let lowPriorityTasks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userDefaults.data(forKey: "lowPriorityTasks")!) as? Array<Task>
            let withoutPriorityTasks = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(userDefaults.data(forKey: "withoutPriorityTasks")!) as? Array<Task>
            
            var arrayOfAllTasks : Array<Task> = []
            arrayOfAllTasks += highPriorityTasks!
            arrayOfAllTasks += mediumPriorityTasks!
            arrayOfAllTasks += lowPriorityTasks!
            arrayOfAllTasks += withoutPriorityTasks!
            
            print("Hey hey heeeeeey", arrayOfAllTasks.count)

            var arrayOfUncheckedTasks : Array<Task> = []
            
            for task in arrayOfAllTasks {
                if !task.checked {
                    arrayOfUncheckedTasks.append(task)
                }
            }
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM HH:mm"
            
            var nearestDate = formatter.date(from: arrayOfUncheckedTasks[0].date)
            var nearestTask = arrayOfUncheckedTasks[0]
            
            for task in arrayOfUncheckedTasks {
                let thisDate = formatter.date(from: task.date)
                
                if thisDate?.compare(nearestDate!) == .orderedAscending {
                    nearestDate = thisDate
                    nearestTask = task
                }
            }
            
            widgetHeadline.text = nearestTask.headline
            widgetDate.text = nearestTask.date
            
        } catch {
            print(error)
        }
    }
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
}
