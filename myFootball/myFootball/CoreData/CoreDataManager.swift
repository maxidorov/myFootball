//
//  CoreDataManager.swift
//  myFootball
//
//  Created by Maxim Sidorov on 05.12.2019.
//  Copyright © 2019 Maxim Sidorov. All rights reserved.
//

import UIKit
import CoreData

enum CoreDataError: LocalizedError {
    case cannotFetch
    case cannotSave
    case cannotDelete
    var localizedDescription: String? {
        switch self {
        case .cannotFetch:
            return NSLocalizedString("Fetching CoreData Error", comment: "")
        case .cannotSave:
            return NSLocalizedString("Saving CoreData Error", comment: "")
        case .cannotDelete:
            return NSLocalizedString("Deleting CoreData Error", comment: "")
        }
    }
}

class CoreDataManager {
    
    static public var shared = CoreDataManager()
    
    private let appDelegate: AppDelegate
    private let managedContext: NSManagedObjectContext
    
    private init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("CoreDataManaged Initialization Error. Have not access to UIApplicationDelegate")
        }
        self.appDelegate = appDelegate
        self.managedContext = self.appDelegate.persistentContainer.viewContext
    }
    
    public func fetch(entityName: String) throws -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoriteTeam")
        let result = try managedContext.fetch(fetchRequest)
        return result
    }
    
    public func save(entityName: String, keyedValues: [String: Any]) throws -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: managedContext)!
        let managedObject = NSManagedObject(entity: entity, insertInto: managedContext)
        managedObject.setValuesForKeys(keyedValues)
        do {
            try managedContext.save()
        } catch {
            throw CoreDataError.cannotSave
        }
        return managedObject
    }
    
    public func delete(object: NSManagedObject) throws {
        managedContext.delete(object)
        do {
            try managedContext.save()
        } catch {
            throw CoreDataError.cannotDelete
        }
    }
}

extension CoreDataManager: NSCopying {
    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
