//
//  TodoListIntentHandler.swift
//  TodoListIntents
//
//  Created by Deisy Melo on 29/03/23.
//

import Foundation
import Intents

class TodoListIntentHandler: NSObject, TodoListIntentHandling {
    func resolveTitle(for intent: TodoListIntent, with completion: @escaping (INStringResolutionResult) -> Void) {
        if let title = intent.title, !title.isEmpty {
            completion(.success(with: title))
        } else {
            completion(.needsValue())
        }
    }
    
    func handle(intent: TodoListIntent, completion: @escaping (TodoListIntentResponse) -> Void) {
        guard let title = intent.title else {
            completion(TodoListIntentResponse(code: .empty, userActivity: nil))
            return
        }
        CoreDataManager().saveItem(title: title)
        completion(TodoListIntentResponse.success(title: title))
    }
}
