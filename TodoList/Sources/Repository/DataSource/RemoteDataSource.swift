//
//  RemoteDataSource.swift
//  TodoList
//
//  Created by Deisy Melo on 6/11/23.
//

import Combine
import FirebaseFirestore
import FirebaseAuth

public class RemoteDataSource: DataSourceProtocol {
    
    var userId: String?
    let firestoreDataBase = Firestore.firestore()
    private let collectionName = "TodosListByUser"
    private let subcollectionName = "TodosList"
    
    public func saveItem(_ item: Item) -> AnyPublisher<Bool, Error> {
        Future { promise in
            guard let userId = self.userId else {
                promise(.failure(DataError.userError))
                return
            }
            
            let dataItem: [String: Any] = [
                "itemDescription": item.description,
                "pending": true,
                "title": item.title
            ]
            
            self.firestoreDataBase
                .collection(self.collectionName)
                .document(userId)
                .collection(self.subcollectionName)
                .document()
                .setData(dataItem)
            
            promise(.success(true))
        }.eraseToAnyPublisher()
    }
    
    public func getItems() -> AnyPublisher<[Item], Error> {
        Future { promise in
            guard let userId = self.userId else {
                promise(.failure(DataError.userError))
                return
            }
            
            let docRef = self.firestoreDataBase
                .collection(self.collectionName)
                .document(userId)
                .collection(self.subcollectionName)

            docRef.getDocuments { (query, err) in
                guard let query = query else {
                    promise(.success([]))
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    return
                }
                
                var list: [Item] = []
                for document in query.documents {
                    let data = document.data()
                    let item = DataItem(
                        id: document.documentID,
                        title: data["title"] as? String ?? "",
                        description: data["itemDescription"] as? String ?? "",
                        pending: data["pending"] as? Bool ?? true
                    )
                    
                    list.append(item)
                }
                promise(.success(list))
            }
        }.eraseToAnyPublisher()
    }
    
    public func getItemBy(_ id: String) -> AnyPublisher<Item?, Error> {
        Future { promise in
            guard let userId = self.userId else {
                promise(.failure(DataError.userError))
                return
            }
            
            let docRef = self.firestoreDataBase
                .collection(self.collectionName)
                .document(userId)
                .collection(self.subcollectionName)

            docRef.document(id).getDocument { document, _ in
                guard let document = document,
                      let data = document.data() else {
                    return promise(.success(nil))
                }
                
                let item = DataItem(
                    id: document.documentID,
                    title: data["title"] as? String ?? "",
                    description: data["itemDescription"] as? String ?? "",
                    pending: data["pending"] as? Bool ?? true
                )
                
                promise(.success(item))
            }
        }.eraseToAnyPublisher()
    }
    
    public func updateStatus(_ id: String) -> AnyPublisher<Item, Error> {
        Future { promise in
            promise(.success(DataItem(title: "prueba", description: "")))
        }.eraseToAnyPublisher()
    }
}
