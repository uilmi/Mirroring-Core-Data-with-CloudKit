//
//  ProductModel.swift
//  Photo_Gallery
//
//  Created by David Gunawan on 05/04/22.
//

import Foundation
import UIKit

struct ProductModel {
    var photoImage: UIImage?
    var photoTitle: String?
    
    func populatePhotos() -> [ProductModel] {
        let photos = [
            ProductModel(photoImage: UIImage(named: "pic-1"), photoTitle: "Alone in the Field"),
            ProductModel(photoImage: UIImage(named: "pic-2"), photoTitle: "Snowboarding"),
            ProductModel(photoImage: UIImage(named: "pic-3"), photoTitle: "Meeting Room"),
            ProductModel(photoImage: UIImage(named: "pic-4"), photoTitle: "Break Time"),
        ]
        return photos
    }
}
