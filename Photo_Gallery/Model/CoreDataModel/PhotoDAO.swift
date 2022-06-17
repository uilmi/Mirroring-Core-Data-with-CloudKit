//
//  PhotoDAO.swift
//  Photo_Gallery
//
//  Created by Jazilul Athoya on 08/04/22.
//

import Foundation
import CoreData

class PhotoDAO {
    
    let coreDataHelper = CoreDataHelper()
    
    // Insert photo
    func insertPhoto(title: String?, image: Data?) {
        let context = coreDataHelper.getBackgroundContext()
        let photo = Photo(context: context)
        photo.image = image
        photo.title = title
        coreDataHelper.saveContext(saveContext: context)
    }
    
    // Fecth all photo
    func fetchPhotos() -> [ProductModel] {
        let context = coreDataHelper.getBackgroundContext()
        let fetchRequest = Photo.fetchRequest()
        do {
            let photos = try context.fetch(fetchRequest)
            let products = photos.map { photo in
                photo.toProductModel()
            }
            return products
        } catch {
            print(error.localizedDescription)
        }
        
        return []
    }
    
    // Delete all photo
    func deleteAllPhoto() {
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Photo.fetchRequest()

        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try coreDataHelper.getBackgroundContext().execute(batchDeleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
}
