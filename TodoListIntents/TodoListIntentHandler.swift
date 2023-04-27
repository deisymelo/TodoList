//
//  TodoListIntentHandler.swift
//  TodoListIntents
//
//  Created by Deisy Melo on 29/03/23.
//

import Foundation
import Intents
import TodoList

class TodoListIntentHandler: NSObject, TodoListIntentHandling {
    
    func handle(intent: TodoListIntent, completion: @escaping (TodoListIntentResponse) -> Void) {
        guard let title = intent.title else {
            completion(TodoListIntentResponse(code: .failure, userActivity: nil))
            return
        }
        CoreDataManager().saveItem(title: title)
        completion(TodoListIntentResponse(code: .success, userActivity: nil))
    }
    
    func resolveTitle(for intent: TodoListIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        guard let title = intent.title,
              title.isEmpty else {
            completion(.needsValue()) // Indica que el parámetro está incompleto
            return
        }
        
        completion(.success(with: title))
    }
}
