//
//  DataController.swift
//  VirtualTouristUdacityProject
//
//  Created by Stefan Weiss on 12.04.22.
//

import Foundation
import CoreData

class DataController {
    
    let persistentContainer: NSPersistentContainer
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
        
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
        persistentContainer.viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    
    func load(_ completionHandler: @escaping (NSPersistentStoreDescription?, Error?) -> Void) {
        persistentContainer.loadPersistentStores(completionHandler: completionHandler)
    }
    
    func save() throws {
        if viewContext.hasChanges {
            try viewContext.save()
        }
    }
    static let shared = DataController(modelName: "VirtualTouristUdacityProject")
}
