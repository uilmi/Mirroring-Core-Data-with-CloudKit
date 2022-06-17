//
//  CoreDataHelper.swift
//  Photo_Gallery
//
//  Created by Jazilul Athoya on 08/04/22.
//

import Foundation
import UIKit
import CoreData

class CoreDataHelper {
    
    let container: NSPersistentCloudKitContainer!
    let viewContext: NSManagedObjectContext!
    
    // Initalize container and context
    init() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        container = appDelegate?.persistentContainer as? NSPersistentCloudKitContainer
        viewContext = container.viewContext
    }
    
    // Create background context to be used with core data operation
    func getBackgroundContext() -> NSManagedObjectContext {
        if let context = container?.newBackgroundContext() {
            return context
        } else {
            return viewContext
        }
    }
    
    // Call save context when changes happen in core data
    func saveContext(saveContext: NSManagedObjectContext? = nil) {
        guard let context = saveContext else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
