import Combine
import CoreData

public final class LocalDataSource: DataSourceProtocol {
    public lazy var persistenContainer: NSPersistentContainer = {
        let storeURL = URL.storeURL(for: "group.zemoga.TodoList", databaseName: "TodoList")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: "TodoList")
        container.persistentStoreDescriptions = [storeDescription]
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

    public init() {}

    private func createDataItemModel(item: TodoItemEntity) -> DataItem {
        let dataItem: DataItem = DataItem(
            id: item.id,
            title: item.title ?? "",
            description: item.itemDescription ?? "",
            pending: item.pending
        )
        return dataItem
    }

    public func saveItem(title: String) {
        let dataItem = DataItem(title: title, description: "new desc")
        saveItem(dataItem)
    }

    public func saveItem(_ item: Item) {
        do {
            let entity = TodoItemEntity(context: context)
            entity.setValue(UUID().uuidString, forKey: "id")
            entity.setValue(item.title, forKey: "title")
            entity.setValue(item.description, forKey: "itemDescription")
            entity.setValue(item.pending, forKey: "pending")
            try context.save()
        } catch {
            print("saveItem: \(error)")
        }
    }

    public func getItems() -> [Item] {
        do {
            let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
            let sortDescriptor = NSSortDescriptor(key: "pending", ascending: false)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let list =  try context.fetch(fetchRequest)
            var todoList: [DataItem] = []
            list.forEach { item in
                todoList.append(createDataItemModel(item: item))
            }

            return todoList
        } catch {
            print("getItems: \(error)")
            return []
        }
    }

    public func getItemBy(_ id: String) -> Item? {
        do {
            let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
            fetchRequest.predicate = NSPredicate(format: "id = %@", id)
            let list =  try context.fetch(fetchRequest)

            guard let item = list.first else {
                return nil
            }

            return createDataItemModel(item: item)
        } catch {
            print("getItemBy id \(id): \(error)")
            return nil
        }
    }

    public func updateStatus(_ id: String) -> AnyPublisher<Item, Error> {
        Future { [context] promise in
            do {
                try context.performAndWait {
                    let fetchRequest = NSFetchRequest<TodoItemEntity>(entityName: "TodoItemEntity")
                    fetchRequest.predicate = NSPredicate(format: "id = %@", id)

                    let list =  try context.fetch(fetchRequest)
                    guard let item = list.first else {
                        promise(.failure(DataError.notFound))
                        return
                    }

                    item.pending = !item.pending

                    let dataItem = self.createDataItemModel(item: item)

                    try context.save()

                    promise(.success(dataItem))
                }

            } catch {
                print("update index \(id): \(error)")
                promise(.failure(error))
            }

        }.eraseToAnyPublisher()
    }
}

public enum DataError: Error {
    case notFound
}

public extension URL {
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
