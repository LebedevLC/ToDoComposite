//
//  Task.swift
//  ToDoComposite
//
//  Created by Сергей Чумовских  on 20.12.2021.
//

import Foundation

class MainTask: TaskProtocol {
    
    var name: String
    var subTask: [SubTask]
    
    init(name: String, subTask: [SubTask]) {
        self.name = name
        self.subTask = subTask
    }
    
    func addSubtask(subTask: SubTask) {
        self.subTask.append(subTask)
    }
}
