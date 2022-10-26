//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Deisy Melo on 21/10/22.
//

import CoreData

final class CoreDataManager {
    lazy var persistenContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores { _, error in
            print(error?.localizedDescription as Any)
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistenContainer.viewContext
    }
    
    func saveItem(_ todoItem: TodoItem) {
        let entity = TodoItemEntity(context: context)
        entity.setValue(todoItem.title, forKey: "title")
        entity.setValue(todoItem.description, forKey: "itemDescription")
        entity.setValue(todoItem.status.rawValue, forKey: "status")
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    func fetchItems() -> [TodoItem] {
        do {
            let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
            let list =  try context.fetch(fetchRequest)
            var todoList: [TodoItem] = []
            list.forEach { item in
                let status = TodoStatus(rawValue: item.status ?? TodoStatus.pending.rawValue) ?? .pending
                let todoItem: TodoItem = TodoItem(title: item.title ?? "",
                                                  description: item.description,
                                                  status: status)
                todoList.append(todoItem)
            }
            
            return todoList
        } catch {
            print(error)
            return []
        }
    }
}
