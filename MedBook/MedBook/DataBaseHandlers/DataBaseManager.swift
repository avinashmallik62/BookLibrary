//
//  DataBaseManager.swift
//  MedBook
//
//  Created by Avinash Kumar on 29/01/24.
//
import CoreData
import UIKit

final class DataBaseManager {
    private var persistentContainer: NSPersistentContainer?
    private var context: NSManagedObjectContext
    private let delegate = (UIApplication.shared.delegate as? AppDelegate)
    private let modelName: String
    
    init(modelName: String) {
        self.modelName = modelName
        persistentContainer = NSPersistentContainer(name: modelName)
        if let persistentContainer = persistentContainer {
            persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
        }
        self.context = persistentContainer!.viewContext
    }
    
    func getContext() -> NSManagedObjectContext {
        return self.context
    }
    
    // MARK: - Core Data Saving support
    
    //SAVE AND UPDATE
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK:- Core Data Methods
    
    func fetchData<T>(request: NSFetchRequest<T>) -> [T] {
        var items = [T]()
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        return items
    }
}
