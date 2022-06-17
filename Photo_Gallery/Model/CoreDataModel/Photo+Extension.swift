//
//  Photo+Extension.swift
//  Photo_Gallery
//
//  Created by Jazilul Athoya on 08/04/22.
//

import Foundation
import UIKit

extension Photo {
    
    func toProductModel() -> ProductModel {
        if let data = self.image {
            return ProductModel(photoImage: UIImage(data: data), photoTitle: self.title)
        } else {
            return ProductModel(photoImage: nil, photoTitle: self.title)
        }
    }
}
