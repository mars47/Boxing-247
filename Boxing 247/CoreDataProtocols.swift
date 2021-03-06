//
//  CoreDataProtocols.swift
//  Boxing 247
//
//  Created by Omar on 14/05/2021.
//  Copyright © 2021 Omar. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

// MARK: - Managed protocol

protocol Managed: class, NSFetchRequestResult {

    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    
    static func managedObject(withJson data: JSON, in context: NSManagedObjectContext)

}

extension Managed {
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest<Self> {
        
        let request = NSFetchRequest<Self>(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        return request
    }
}

extension Managed where Self: NSManagedObject {
    
    static var entityName: String {
        return entity().name!
    }
}

// MARK: - Updatable sub protocol

protocol Updatable: Managed {
    
    static var dataIdentifier: String { get set }
    static var objectIdentifier: String { get set }
    
    func update(with json: JSON)
}

extension Updatable where Self: NSManagedObject {
    
    static func managedObject(withJson json: JSON, in context: NSManagedObjectContext) {
        
        guard
            let objectId = json.dictionary?[dataIdentifier]?.number?.stringValue
            ?? json.dictionary?[dataIdentifier]?.string else { return }
        
        if let object = Self.object(withId: objectId, in: context) {
            
            object.update(with: json)
            
        } else {
            
            let object = Self(entity: self.entity(), insertInto: context)
            
            object.update(with: json)
        }
    }
    
    static func object(withId id: String, in context: NSManagedObjectContext) -> Self? {
        
        return try? context.fetch(fetchRequest(forId: id)).first as? Self ?? nil
    }
    
    static func fetchAll() -> [Self] {
        
        return (try? CoreDataManager.shared.container.viewContext.fetch(self.sortedFetchRequest) as [Self]) ?? []
    }
    
    func eraseCurrent<T: NSManagedObject>(elements: Set<T>?) {
        
        if let elements = elements, !elements.isEmpty {
            for element in elements {
                managedObjectContext?.delete(element)
            }
        }
    }
    
    private static func fetchRequest(forId id: String) -> NSFetchRequest<NSFetchRequestResult> {
        
        let request = self.sortedFetchRequest

        request.predicate = NSPredicate(format: "%K == %@", objectIdentifier, id)
        return request as! NSFetchRequest<NSFetchRequestResult>
    }
}
