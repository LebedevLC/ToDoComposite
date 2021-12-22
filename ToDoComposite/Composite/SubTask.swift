//
//  SubTask.swift
//  ToDoComposite
//
//  Created by Сергей Чумовских  on 20.12.2021.
//

import Foundation

class SubTask: TaskProtocol {
    
    var name: String
    var mainTask: MainTask
    var subTask: [SubTask] = []
    
    init(name: String, mainTask: MainTask) {
        self.name = name
        self.mainTask = mainTask
    }
    
    func addSubtask(subTask: SubTask) {
        self.subTask.append(subTask)
    }
}
