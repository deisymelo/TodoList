//
//  IntentHandler.swift
//  TodoListIntents
//
//  Created by Andres Rojas on 2/05/23.
//

import Intents

class IntentHandler: INExtension {
    override func handler(for intent: INIntent) -> Any {
        return TodoListIntentHandler()
    }
}
