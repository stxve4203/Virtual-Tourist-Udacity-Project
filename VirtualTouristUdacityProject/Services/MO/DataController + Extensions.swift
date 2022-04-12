//
//  DataController + Extensions.swift
//  Virtual-Tourist-Udacity
//
//  Created by Stefan Weiss on 08.04.22.
//

import Foundation
import CoreData

extension DataController {
    
    func fetchLocation(_ predicate: NSPredicate, sorting: NSSortDescriptor? = nil ) throws -> Pin? {
    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchRequest.predicate = predicate
        if let sorting = sorting {
            fetchRequest.sortDescriptors = [sorting]
        }
        guard let location = (try viewContext.fetch(fetchRequest) as! [Pin]).first else {
            return nil
        }
        return location
}
    
    func fetchAllLocations() throws -> [Pin]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        guard let allLocations = try viewContext.fetch(fetchRequest) as? [Pin] else {
            print("Error fetching all locations")
            return nil
        }
        return allLocations
    }
    
    func fetchImages(_ predicate: NSPredicate?, sorting: NSSortDescriptor?) throws -> [Photo]? {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Photo")
        fetchRequest.predicate = predicate
        if let sorting = sorting {
            fetchRequest.sortDescriptors = [sorting]
        }
        guard let allImages = try viewContext.fetch(fetchRequest) as? [Photo] else {
            print("Error fetching all images.")
            return nil
        }
        return allImages
    }
}
