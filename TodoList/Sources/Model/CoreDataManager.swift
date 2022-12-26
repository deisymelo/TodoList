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
    func getItemBy(_ id: String) -> TodoItem?
    func updateStatus(_ id: String) -> AnyPublisher<TodoItem, Error>
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
    
    private func createTodoItemModel(item: TodoItemEntity) -> TodoItem {
        let todoItem: TodoItem = TodoItem(id: item.id,
                                          title: item.title ?? "",
                                          description: item.itemDescription ?? "",
                                          pending: item.pending)
        return todoItem
    }
    
    func saveItem(_ todoItem: TodoItem) {
        let entity = TodoItemEntity(context: context)
        entity.setValue(UUID().uuidString, forKey: "id")
        entity.setValue(todoItem.title, forKey: "title")
        entity.setValue(todoItem.description, forKey: "itemDescription")
        entity.setValue(todoItem.pending, forKey: "pending")
        
        do {
            try context.save()
        } catch {
            print("saveItem: \(error)")
        }
    }
    
    func getItems() -> [TodoItem] {
        do {
            let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
            let sortDescriptor = NSSortDescriptor(key: "pending", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let list =  try context.fetch(fetchRequest)
            var todoList: [TodoItem] = []
            list.forEach { item in
                todoList.append(createTodoItemModel(item: item))
            }
            
            return todoList
        } catch {
            print("getItems: \(error)")
            return []
        }
    }
    
    func getItemBy(_ id: String) -> TodoItem? {
        do {
            let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            let list =  try context.fetch(fetchRequest)
            
            guard let item = list.first else {
                return nil
            }
            
            return createTodoItemModel(item: item)
        } catch {
            print("getItemBy id \(id): \(error)")
            return nil
        }
    }
    
    func updateStatus(_ id: String) -> AnyPublisher<TodoItem, Error> {
        Future { [context] promise in
            do {
                try context.performAndWait {
                    let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
                    fetchRequest.predicate = NSPredicate(format: "id = %@", id)
                    
                    let list =  try context.fetch(fetchRequest)
                    guard let item = list.first else {
                        promise(.failure(CustomError.notFound))
                        return
                    }
                    
                    item.pending = !item.pending
                    
                    let todoItem = self.createTodoItemModel(item: item)
                    
                    try context.save()
                    
                    promise(.success(todoItem))
                }
                
            } catch {
                print("update index \(id): \(error)")
                promise(.failure(error))
            }
            
        }.eraseToAnyPublisher()
    }
}
