//
//  ToDoSingleton.swift
//  ToDoComposite
//
//  Created by Сергей Чумовских  on 22.12.2021.
//

import Foundation

final class ToDoSingleton {
    
    static let shared = ToDoSingleton()
    
    var mainTask: MainTask?
    
    private init() {}
    
}
