//
//  CoreDataManager.swift
//  TodoList
//
//  Created by Deisy Melo on 21/10/22.
//

import CoreData
import Combine

protocol CoreDataManagerProtocol {
    func saveItem(_ todoItem: TodoItem)
    func getItems() -> [TodoItem]
    func getItemBy(_ index: Int) -> TodoItem?
    func updateStatus(_ item: Int) -> AnyPublisher<TodoItem, Error> 
}

final class CoreDataManager: CoreDataManagerProtocol {
    lazy var persistenContainer: NSPersistentContainer = {
       let container = NSPersistentContainer(name: "TodoList")
        container.loadPersistentStores { _, error in
            if let error = error as? NSError {
                fatalError("persistenContainer: \(error.userInfo)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistenContainer.viewContext
    }
    
    private func getTodoItem(item: TodoItemEntity) -> TodoItem {
        let status = TodoStatus(rawValue: item.status ?? TodoStatus.pending.rawValue) ?? .pending
        let todoItem: TodoItem = TodoItem(title: item.title ?? "",
                                          description: item.itemDescription ?? "",
                                          status: status)
        return todoItem
    }
    
    func saveItem(_ todoItem: TodoItem) {
        let entity = TodoItemEntity(context: context)
        entity.setValue(todoItem.title, forKey: "title")
        entity.setValue(todoItem.description, forKey: "itemDescription")
        entity.setValue(todoItem.status.rawValue, forKey: "status")
        
        do {
            try context.save()
        } catch {
            print("saveItem: \(error)")
        }
    }
    
    func getItems() -> [TodoItem] {
        do {
            let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
            let list =  try context.fetch(fetchRequest)
            var todoList: [TodoItem] = []
            list.forEach { item in
                todoList.append(getTodoItem(item: item))
            }
            
            return todoList
        } catch {
            print("getItems: \(error)")
            return []
        }
    }
    
    func getItemBy(_ index: Int) -> TodoItem? {
        do {
            let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
            let list =  try context.fetch(fetchRequest)
            let item = list[index]
            return getTodoItem(item: item)
        } catch {
            print("getItemBy index \(index): \(error)")
            return nil
        }
    }
    
    func updateStatus(_ item: Int) -> AnyPublisher<TodoItem, Error> {
        Future { [context] promise in
            do {
                try context.performAndWait {
                    let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
                    let list =  try context.fetch(fetchRequest)
                    let item = list[item]
                    
                    if item.status == TodoStatus.pending.rawValue {
                        item.status = TodoStatus.finished.rawValue
                    } else {
                        item.status = TodoStatus.pending.rawValue
                    }
                    
                    let todoItem = self.getTodoItem(item: item)
                    
                    try context.save()
                    
                    promise(.success(todoItem))
                }
                
            } catch {
                print("getItemBy index \(item): \(error)")
                promise(.failure(error))
            }
            
        }.eraseToAnyPublisher()
    }
}
